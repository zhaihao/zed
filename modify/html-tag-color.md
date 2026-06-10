# Zed HTML 扩展修改记录

## 日期

- 2026-06-10: 初始版本
- 2026-06-11: **修复查询语法** - 括号必须换行

## 修改内容

### 1. HTML 标签颜色自定义

为 Zed 的 HTML 扩展添加了标签颜色自定义功能，允许用户为不同的 HTML 标签设置不同的颜色。

#### 修改文件

**`/Users/zhaihao/Code/zed/zed/extensions/html/languages/html/highlights.scm`**

添加了特定标签的捕获规则，使每个标签可以使用独立的颜色样式：

**⚠️ 重要：正确的查询语法**

```scm
;; 结构性标签 - 蓝紫色系
((start_tag
  "<" @tag.div.bracket
  (tag_name) @tag.div (#eq? @tag.div "div")
  ">" @tag.div.bracket))
((end_tag
  "</" @tag.div.bracket
  (tag_name) @tag.div (#eq? @tag.div "div")
  ">" @tag.div.bracket))

;; ... 更多标签规则
```

**关键点：括号必须换行**

在 tree-sitter 查询中，`<` 和 `>` 是 `start_tag`/`end_tag` 节点的子节点，必须换行书写才能正确匹配。如果将括号写在同一行内，查询会失败，标签不会显示颜色。

❌ **错误语法**（括号在同一行）：
```scm
((start_tag "<" @tag.div.bracket (tag_name) @tag.div (#eq? @tag.div "div") ">" @tag.div.bracket))
```

✅ **正确语法**（括号换行）：
```scm
((start_tag
  "<" @tag.div.bracket
  (tag_name) @tag.div (#eq? @tag.div "div")
  ">" @tag.div.bracket))
```

**`~/Library/Application Support/Zed/extensions/installed/html/languages/html/highlights.scm`**

将修改后的文件复制到 Zed 扩展目录（Zed 会自动重载）。

**`~/Code/osx-env/config/zed/settings.json`**

添加了标签颜色配置：

```json
"experimental.theme_overrides": {
  "syntax": {
    // 结构性标签 - 蓝紫色系
    "tag.div": { "color": "#61afef" },
    "tag.div.bracket": { "color": "#61afef" },
    "tag.span": { "color": "#56b6c2" },
    // ... 更多颜色配置
  }
}
```

### 2. 颜色方案

采用 VSCode Colorful Tags 风格的多彩配色方案，每个标签都有独特的颜色：

**文档结构**
- `html`: `#ccaacc`
- `head`: `#ddaaff`
- `body`: `#a9ffb3`
- `title`: `#ffcccc`
- `meta`: `#aaffff`
- `base`: `#aeff00`

**结构性标签**
- `div`: `#ffffc8` (浅黄)
- `span`: `#aaddff` (浅蓝)
- `header`: `#ffaaaa` (粉红)
- `footer`: `#ffe400` (黄)
- `main`: `#42ff00` (亮绿)
- `section`: `#ffccdd` (粉)
- `article`: `#ffcc00` (橙黄)
- `nav`: `#00ffff` (青)
- `aside`: `#ffca96` (橙)

**标题标签（彩虹渐变）**
- `h1`: `#ff8282` (红)
- `h2`: `#ff8ad8` (粉紫)
- `h3`: `#e7e578` (黄)
- `h4`: `#a3ff99` (绿)
- `h5`: `#5edfff` (青)
- `h6`: `#cca0ff` (紫)

**文本格式**
- `p`: `#ffcc00` (橙黄)
- `strong`: `#ffcc99` (橙)
- `em`: `#ef71ff` (紫)
- `b`: `#eeaaff` (淡紫)
- `i`: `#ffff80` (淡黄)
- `code`: `#aaddaa` (淡绿)
- `pre`: `#ffb399` (橙)

**链接**
- `a`: `#5aff7b` (亮绿)
- `link`: `#9cff83` (绿)

**列表**
- `ul`: `#ffffaa` (淡黄)
- `ol`: `#99aacc` (蓝灰)
- `li`: `#ffbbbb` (粉)
- `dl`: `#ee9933` (橙)
- `dt`: `#99ddff` (淡蓝)
- `dd`: `#dd99dd` (紫)

**表格**
- `table`: `#eeff99` (淡黄绿)
- `thead`: `#ff8888` (红)
- `tbody`: `#ffccbb` (橙)
- `tfoot`: `#23e2ff` (青)
- `tr`: `#aaeecc` (淡绿)
- `td`: `#ffff88` (黄)
- `th`: `#ff99ff` (紫)

**表单**
- `form`: `#00ffc6` (青绿)
- `input`: `#ddcccc` (灰)
- `button`: `#ffbbbb` (粉)
- `select`: `#ccffff` (淡青)
- `textarea`: `#ed99dd` (紫)
- `label`: `#ff7e00` (橙)

**媒体**
- `img`: `#48ddff` (青)
- `video`: `#eeffcc` (淡黄绿)
- `audio`: `#a1ffd0` (青绿)
- `svg`: `#66ffdd` (青绿)
- `canvas`: `#66ccff` (青蓝)

**脚本**
- `script`: `#42e0ff` (青蓝)
- `style`: `#ffaa00` (橙)
- `noscript`: `#ff7979` (红)

**其他**
- `br`: `#aaffaa` (淡绿)
- `hr`: `#ffcc77` (橙)
- `figure`: `#e6eecc` (淡黄绿)
- `figcaption`: `#aaddff` (淡蓝)
- `address`: `#eeee66` (黄)
- `blockquote`: `#ffb7ad` (粉)
- `q`: `#ffb7ad` (粉)
- `cite`: `#ff8888` (红)

### 3. HTML 属性颜色

添加了 HTML 属性的颜色配置：

```json
"attribute": { "color": "#e5c07b" }
```

### 4. 探索：HTML 彩虹括号

**结论：Zed 不支持 HTML 标签的彩虹括号**

经过探索发现，Zed 的彩虹括号功能（`colorize_brackets`）不支持 HTML 标签的 `<>` 括号。原因：

1. **括号匹配逻辑**: Zed 的彩虹括号是为传统编程语言设计的，只支持 `()`, `[]`, `{}` 等单字符括号对
2. **实现限制**: 在 `buffer.rs` 中有长度检查，只对单字符括号进行彩虹着色
3. **HTML 特殊性**: HTML 的 `<` 符号有多种配对方式（`>`, `/>`），不符合彩虹括号的配对逻辑

**相关代码位置：**

- `/Users/zhaihao/Code/zed/zed/crates/editor/src/bracket_colorization.rs`
- `/Users/zhaihao/Code/zed/zed/crates/language/src/buffer.rs` (line 4922-4929)

## 使用方法

1. 复制 `highlights.scm` 到 Zed 扩展目录
2. 在 `settings.json` 中添加颜色配置
3. Zed 会自动重载，无需重启

## 效果

- ✅ 标签名有自定义颜色
- ✅ 括号与标签名同色
- ✅ 整个 `<div></div>` 会显示为相同的颜色
- ❌ 彩虹括号不支持（Zed 限制）

## 待提交

考虑将这些改进提交给 Zed 官方仓库：

- https://github.com/zed-industries/zed
