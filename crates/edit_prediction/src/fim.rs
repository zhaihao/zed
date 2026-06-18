use crate::{
    EditPredictionId, EditPredictionModelInput, cursor_excerpt,
    open_ai_compatible::{self, load_open_ai_compatible_api_key_if_needed},
    prediction::EditPredictionResult,
};
use anyhow::{Context as _, Result, anyhow};
use gpui::{App, AppContext as _, Entity, Task};
use language::{
    Anchor, Buffer, BufferSnapshot, EditPredictionPromptFormat, ToOffset, ToPoint as _,
    language_settings::all_language_settings,
};
use std::{path::Path, sync::Arc, time::Instant};
use zeta_prompt::{ZetaPromptInput, compute_editable_and_context_ranges};

const FIM_CONTEXT_TOKENS: usize = 512;

struct FimRequestOutput {
    request_id: String,
    edits: Vec<(std::ops::Range<Anchor>, Arc<str>)>,
    editable_range: std::ops::Range<Anchor>,
    snapshot: BufferSnapshot,
    inputs: ZetaPromptInput,
    buffer: Entity<Buffer>,
}

pub fn request_prediction(
    EditPredictionModelInput {
        buffer,
        snapshot,
        position,
        events,
        trigger,
        ..
    }: EditPredictionModelInput,
    prompt_format: EditPredictionPromptFormat,
    cx: &mut App,
) -> Task<Result<Option<EditPredictionResult>>> {
    let settings = &all_language_settings(None, cx).edit_predictions;
    let provider = settings.provider;

    let full_path: Arc<Path> = snapshot
        .file()
        .map(|file| file.full_path(cx))
        .unwrap_or_else(|| "untitled".into())
        .into();

    let http_client = cx.http_client();
    let cursor_point = position.to_point(&snapshot);
    let request_start = cx.background_executor().now();

    let Some(settings) = (match provider {
        settings::EditPredictionProvider::Ollama => settings.ollama.clone(),
        settings::EditPredictionProvider::OpenAiCompatibleApi => {
            settings.open_ai_compatible_api.clone()
        }
        _ => None,
    }) else {
        return Task::ready(Err(anyhow!("Unsupported edit prediction provider for FIM")));
    };

    let api_key = load_open_ai_compatible_api_key_if_needed(provider, cx);

    let result = cx.background_spawn(async move {
        let cursor_offset = cursor_point.to_offset(&snapshot);
        let (excerpt_point_range, excerpt_offset_range, cursor_offset_in_excerpt) =
            cursor_excerpt::compute_cursor_excerpt(&snapshot, cursor_offset);
        let cursor_excerpt: Arc<str> = snapshot
            .text_for_range(excerpt_point_range.clone())
            .collect::<String>()
            .into();
        let syntax_ranges =
            cursor_excerpt::compute_syntax_ranges(&snapshot, cursor_offset, &excerpt_offset_range);
        let (editable_range, _) = compute_editable_and_context_ranges(
            &cursor_excerpt,
            cursor_offset_in_excerpt,
            &syntax_ranges,
            FIM_CONTEXT_TOKENS,
            0,
        );

        let inputs = ZetaPromptInput {
            events,
            related_files: Some(Vec::new()),
            active_buffer_diagnostics: Vec::new(),
            cursor_offset_in_excerpt: cursor_offset - excerpt_offset_range.start,
            cursor_path: full_path.clone(),
            excerpt_start_row: Some(excerpt_point_range.start.row),
            cursor_excerpt,
            excerpt_ranges: Default::default(),
            syntax_ranges: None,
            in_open_source_repo: false,
            can_collect_data: false,
            repo_url: None,
        };

        let editable_text = &inputs.cursor_excerpt[editable_range.clone()];
        let cursor_in_editable = cursor_offset_in_excerpt.saturating_sub(editable_range.start);
        let prefix = editable_text[..cursor_in_editable].to_string();
        let suffix = editable_text[cursor_in_editable..].to_string();
        let prompt = format_fim_prompt(prompt_format, &prefix, &suffix);
        let stop_tokens = get_fim_stop_tokens();

        let max_tokens = settings.max_output_tokens;

        let (response_text, request_id) = open_ai_compatible::send_custom_server_request(
            provider,
            &settings,
            prompt,
            max_tokens,
            stop_tokens,
            api_key,
            &http_client,
        )
        .await?;

        let response_received_at = Instant::now();

        log::debug!(
            "fim: completion received ({:.2}s)",
            (response_received_at - request_start).as_secs_f64()
        );

        let cleaned = clean_fim_completion(&response_text);
        let completion: Arc<str> = trim_suffix_overlap(&cleaned, &suffix).into();
        let edits = if completion.is_empty() {
            vec![]
        } else {
            let cursor_offset = cursor_point.to_offset(&snapshot);
            let anchor = snapshot.anchor_after(cursor_offset);
            vec![(anchor..anchor, completion)]
        };

        let editable_range = snapshot.anchor_range_inside(
            (excerpt_offset_range.start + editable_range.start)
                ..(excerpt_offset_range.start + editable_range.end),
        );

        anyhow::Ok(FimRequestOutput {
            request_id,
            edits,
            editable_range,
            snapshot,
            inputs,
            buffer,
        })
    });

    cx.spawn(async move |cx: &mut gpui::AsyncApp| {
        let output = result.await.context("fim edit prediction failed")?;
        anyhow::Ok(Some(
            EditPredictionResult::new(
                EditPredictionId(output.request_id.into()),
                &output.buffer,
                &output.snapshot,
                output.edits.into(),
                None,
                Some(output.editable_range),
                output.inputs,
                None,
                trigger,
                cx.background_executor().now() - request_start,
                cx,
            )
            .await,
        ))
    })
}

fn format_fim_prompt(
    prompt_format: EditPredictionPromptFormat,
    prefix: &str,
    suffix: &str,
) -> String {
    match prompt_format {
        EditPredictionPromptFormat::CodeLlama => {
            format!("<PRE> {prefix} <SUF>{suffix} <MID>")
        }
        EditPredictionPromptFormat::StarCoder => {
            format!("<fim_prefix>{prefix}<fim_suffix>{suffix}<fim_middle>")
        }
        EditPredictionPromptFormat::DeepseekCoder => {
            format!("<｜fim▁begin｜>{prefix}<｜fim▁hole｜>{suffix}<｜fim▁end｜>")
        }
        EditPredictionPromptFormat::Qwen | EditPredictionPromptFormat::CodeGemma => {
            format!("<|fim_prefix|>{prefix}<|fim_suffix|>{suffix}<|fim_middle|>")
        }
        EditPredictionPromptFormat::Codestral => {
            format!("[SUFFIX]{suffix}[PREFIX]{prefix}")
        }
        EditPredictionPromptFormat::Glm => {
            format!("<|code_prefix|>{prefix}<|code_suffix|>{suffix}<|code_middle|>")
        }
        _ => {
            format!("<fim_prefix>{prefix}<fim_suffix>{suffix}<fim_middle>")
        }
    }
}

fn get_fim_stop_tokens() -> Vec<String> {
    vec![
        "<|endoftext|>".to_string(),
        "<|file_separator|>".to_string(),
        "<|fim_pad|>".to_string(),
        "<|fim_prefix|>".to_string(),
        "<|fim_middle|>".to_string(),
        "<|fim_suffix|>".to_string(),
        "<fim_prefix>".to_string(),
        "<fim_middle>".to_string(),
        "<fim_suffix>".to_string(),
        "<PRE>".to_string(),
        "<SUF>".to_string(),
        "<MID>".to_string(),
        "[PREFIX]".to_string(),
        "[SUFFIX]".to_string(),
    ]
}

fn clean_fim_completion(response: &str) -> String {
    let mut result = response.to_string();

    let end_tokens = [
        "<|endoftext|>",
        "<|file_separator|>",
        "<|fim_pad|>",
        "<|fim_prefix|>",
        "<|fim_middle|>",
        "<|fim_suffix|>",
        "<fim_prefix>",
        "<fim_middle>",
        "<fim_suffix>",
        "<PRE>",
        "<SUF>",
        "<MID>",
        "[PREFIX]",
        "[SUFFIX]",
    ];

    for token in &end_tokens {
        if let Some(pos) = result.find(token) {
            result.truncate(pos);
        }
    }

    result
}

/// Remove the maximum overlap between the tail of `generated` and the head of
/// `suffix`.
///
/// Many code models (Qwen3-Coder, Codestral, DeepSeek-Coder, ...) re-emit part
/// of the suffix they were given. Applying such a completion verbatim would
/// duplicate that text in the buffer, so we trim it before inserting.
///
/// Whitespace differences are tolerated during comparison: `") {"` matches
/// `" ) {"`. The cut is performed on the original `generated`, removing the
/// matched non-whitespace characters together with any whitespace that sits
/// between them and the rest of the completion.
fn trim_suffix_overlap<'a>(generated: &'a str, suffix: &str) -> &'a str {
    let gen_nonws: Vec<char> = generated.chars().filter(|c| !c.is_whitespace()).collect();
    let suf_nonws: Vec<char> = suffix.chars().filter(|c| !c.is_whitespace()).collect();

    // Find the largest k such that the tail of `gen_nonws` equals the head of
    // `suf_nonws`.
    let max_k = gen_nonws.len().min(suf_nonws.len());
    let mut best_k = 0;
    for k in (1..=max_k).rev() {
        if gen_nonws[gen_nonws.len() - k..] == suf_nonws[..k] {
            best_k = k;
            break;
        }
    }

    if best_k == 0 {
        return generated;
    }

    // Walk the original `generated` from the end. We need to drop the last
    // `best_k` non-whitespace characters plus any whitespace trailing right
    // before them. Count off the non-whitespace characters first; once counted,
    // keep eating preceding whitespace. `cut_byte` is the earliest byte index
    // still belonging to the dropped region.
    let mut remaining = best_k;
    let mut cut_byte = generated.len();
    for (byte_idx, ch) in generated.char_indices().rev() {
        if ch.is_whitespace() {
            if remaining == 0 {
                // Whitespace immediately preceding the matched tail: drop it.
                cut_byte = byte_idx;
                continue;
            } else {
                // Whitespace interleaved within the matched characters: drop it.
                cut_byte = byte_idx;
                continue;
            }
        }

        if remaining == 0 {
            break;
        }

        remaining -= 1;
        cut_byte = byte_idx;
    }

    if remaining > 0 {
        return generated;
    }

    &generated[..cut_byte]
}

#[cfg(test)]
mod tests {
    use super::trim_suffix_overlap;

    #[test]
    fn example_1_person_counter() {
        // fim.md 示例 1
        let generated = "{ person: string }) {";
        let suffix = ") {\n  return <></>\n}";
        assert_eq!(trim_suffix_overlap(generated, suffix), "{ person: string }");
    }

    #[test]
    fn example_2_html_div() {
        // fim.md 示例 2
        let generated = "<p>Hello</p></div>";
        let suffix = "</div>";
        assert_eq!(trim_suffix_overlap(generated, suffix), "<p>Hello</p>");
    }

    #[test]
    fn example_3_foo_brace() {
        // fim.md 示例 3：generated 末尾的 `\n}` 与 suffix 的 `}` 重叠，
        // 匹配的非空白字符是 `}`，紧贴它的 `\n` 也一并删除。
        let generated = "foo();\n}";
        let suffix = "}";
        assert_eq!(trim_suffix_overlap(generated, suffix), "foo();");
    }

    #[test]
    fn whitespace_tolerant_paren_brace() {
        // fim.md 空白处理：generated `) {` vs suffix ` ) {`，忽略空白后
        // 整段都是重叠，结果为空。
        assert_eq!(trim_suffix_overlap(") {", " ) {"), "");
    }

    #[test]
    fn newline_then_brace_vs_brace() {
        // fim.md 空白处理：generated `\n}` vs suffix `}`。
        assert_eq!(trim_suffix_overlap("\n}", "}"), "");
    }

    #[test]
    fn no_overlap() {
        assert_eq!(trim_suffix_overlap("foo()", "}"), "foo()");
        assert_eq!(trim_suffix_overlap("abc", "xyz"), "abc");
    }

    #[test]
    fn empty_generated() {
        assert_eq!(trim_suffix_overlap("", "abc"), "");
    }

    #[test]
    fn empty_suffix() {
        assert_eq!(trim_suffix_overlap("abc", ""), "abc");
    }

    #[test]
    fn fully_repeated_suffix() {
        // 整段生成都是 suffix 开头内容的复读 -> 全部删除。
        assert_eq!(trim_suffix_overlap("}", "}"), "");
        assert_eq!(trim_suffix_overlap("</div>", "</div>"), "");
    }

    #[test]
    fn multiline_overlap_block_boundary() {
        // fim.md 常见重复：`) {` block 边界跨行。
        let generated = "let x = 1\n) {\n}";
        let suffix = ") {\n}";
        assert_eq!(trim_suffix_overlap(generated, suffix), "let x = 1");
    }

    #[test]
    fn utf8_multibyte_boundary() {
        // 多字节字符不应被切断。
        let generated = "你好世界】";
        let suffix = "】结尾";
        assert_eq!(trim_suffix_overlap(generated, suffix), "你好世界");
    }

    #[test]
    fn keeps_unrelated_trailing_whitespace() {
        // 没有重叠时，generated 末尾空白保留。
        assert_eq!(trim_suffix_overlap("foo();\n", "}"), "foo();\n");
    }

    #[test]
    fn partial_overlap_in_middle() {
        // generated 末尾 `</span>` 与 suffix `</span>` 重叠，
        // 但 generated 前面还有 `<li>x</li>` 之间有空格，重叠部分之前的内容保留。
        let generated = "<li>x</li> </span>";
        let suffix = "</span></ul>";
        assert_eq!(trim_suffix_overlap(generated, suffix), "<li>x</li>");
    }
}
