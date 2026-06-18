# 实现 FIM Completion 的 Suffix Overlap Trimming

## 问题

当前 Zed 在接受 FIM（Fill-In-the-Middle）补全结果时，会直接将模型生成的内容原样插入。

许多代码模型（Qwen3-Coder、Codestral、DeepSeek-Coder 等）在生成 middle 时，会自然地重新生成一部分已经存在于 suffix 中的内容。

例如：

已有代码：

```ts
function PersonCounter({ person }:| ) {
  return <></>
}
```

其中：

prefix：

```ts
function PersonCounter({ person }:
```

suffix：

```ts
 ) {
  return <></>
}
```

模型生成：

```ts
{ person: string }) {
```

当前结果：

```ts
function PersonCounter({ person }:{ person: string }) {
 ) {
  return <></>
}
```

可以看到 `) {` 被重复插入。

---

## 目标

在应用补全之前，对：

- 模型生成结果 generated
- 当前已有 suffix

执行 overlap trimming。

寻找：

- generated 的结尾
- suffix 的开头

之间的最大重叠部分，并将其从 generated 中删除。

行为应与：

- GitHub Copilot
- Cursor
- Continue

保持一致。

---

## 示例 1

suffix：

```ts
) {
  return <></>
}
```

模型生成：

```ts
{ person: string }) {
```

检测到重叠：

```ts
) {
```

最终插入：

```ts
{
  person: string;
}
```

最终代码：

```ts
function PersonCounter({ person }:{ person: string } ) {
  return <></>
}
```

---

## 示例 2

suffix：

```html
</div>
```

模型生成：

```html
<p>Hello</p></div>
```

检测到重叠：

```html
</div>
```

最终插入：

```html
<p>Hello</p>
```

---

## 示例 3

suffix：

```js
}
```

模型生成：

```js
foo();
}
```

最终插入：

```js
foo();
```

---

## 算法

寻找最大的 k，使得：

```text
generated.ends_with(suffix[0:k])
```

然后删除重叠部分：

```text
generated = generated[0:-k]
```

伪代码：

```rust
fn trim_suffix_overlap(generated: &str, suffix: &str) -> String {
    let max_len = generated.len().min(suffix.len());

    for k in (1..=max_len).rev() {
        if generated.ends_with(&suffix[..k]) {
            return generated[..generated.len() - k].to_string();
        }
    }

    generated.to_string()
}
```

---

## 空白字符处理

重叠检测应尽量忽略空白字符差异。

例如：

generated：

```text
") {"
```

suffix：

```text
" ) {"
```

应当视为：

```text
") {"
```

与

```text
") {"
```

相同。

类似：

generated：

```text
"\n}"
```

suffix：

```text
"}"
```

也应能够识别重叠。

建议：

比较时对空白字符进行 normalize，但最终插入时保留原始 generated 内容。

---

## 常见重复问题

需要解决以下重复内容：

```text
}
))
]
>;
);
</div>
</span>
</li>
```

以及：

```text
) {
}
};
```

等 block 边界。

---

## 修改位置

请查找：

> FIM completion 被接受并与当前 buffer 合并的代码路径。

在真正应用 edit 之前，对：

- generated completion
- existing suffix

执行 overlap trimming。

不要修改模型请求，不要修改 prompt。

只在最终应用补全之前增加后处理逻辑。

---

## 目标效果

补全结果应该只包含真正缺失的 middle 部分，而不应包含任何已经存在于 suffix 开头的内容。

最终效果应与 GitHub Copilot、Cursor、Continue 保持一致。
