(tag_name) @tag

(doctype) @tag.doctype

(attribute_name) @attribute

[
  "\""
  "'"
  (attribute_value)
] @string

(comment) @comment

(entity) @string.special

"=" @punctuation.delimiter.html

[
  "<"
  ">"
  "<!"
  "</"
  "/>"
] @punctuation.bracket.html

;; HTML Tag Colors - 使用正确的语法（括号换行）
;; 在 settings.json 中添加对应的颜色配置

;; Document structure
((start_tag
  "<" @tag.html.bracket
  (tag_name) @tag.html (#eq? @tag.html "html")
  ">" @tag.html.bracket))
((end_tag
  "</" @tag.html.bracket
  (tag_name) @tag.html (#eq? @tag.html "html")
  ">" @tag.html.bracket))

((start_tag
  "<" @tag.head.bracket
  (tag_name) @tag.head (#eq? @tag.head "head")
  ">" @tag.head.bracket))
((end_tag
  "</" @tag.head.bracket
  (tag_name) @tag.head (#eq? @tag.head "head")
  ">" @tag.head.bracket))

((start_tag
  "<" @tag.body.bracket
  (tag_name) @tag.body (#eq? @tag.body "body")
  ">" @tag.body.bracket))
((end_tag
  "</" @tag.body.bracket
  (tag_name) @tag.body (#eq? @tag.body "body")
  ">" @tag.body.bracket))

((start_tag
  "<" @tag.title.bracket
  (tag_name) @tag.title (#eq? @tag.title "title")
  ">" @tag.title.bracket))
((end_tag
  "</" @tag.title.bracket
  (tag_name) @tag.title (#eq? @tag.title "title")
  ">" @tag.title.bracket))

;; Structural tags
((start_tag
  "<" @tag.div.bracket
  (tag_name) @tag.div (#eq? @tag.div "div")
  ">" @tag.div.bracket))
((end_tag
  "</" @tag.div.bracket
  (tag_name) @tag.div (#eq? @tag.div "div")
  ">" @tag.div.bracket))

((start_tag
  "<" @tag.span.bracket
  (tag_name) @tag.span (#eq? @tag.span "span")
  ">" @tag.span.bracket))
((end_tag
  "</" @tag.span.bracket
  (tag_name) @tag.span (#eq? @tag.span "span")
  ">" @tag.span.bracket))

((start_tag
  "<" @tag.header.bracket
  (tag_name) @tag.header (#eq? @tag.header "header")
  ">" @tag.header.bracket))
((end_tag
  "</" @tag.header.bracket
  (tag_name) @tag.header (#eq? @tag.header "header")
  ">" @tag.header.bracket))

((start_tag
  "<" @tag.footer.bracket
  (tag_name) @tag.footer (#eq? @tag.footer "footer")
  ">" @tag.footer.bracket))
((end_tag
  "</" @tag.footer.bracket
  (tag_name) @tag.footer (#eq? @tag.footer "footer")
  ">" @tag.footer.bracket))

((start_tag
  "<" @tag.main.bracket
  (tag_name) @tag.main (#eq? @tag.main "main")
  ">" @tag.main.bracket))
((end_tag
  "</" @tag.main.bracket
  (tag_name) @tag.main (#eq? @tag.main "main")
  ">" @tag.main.bracket))

((start_tag
  "<" @tag.section.bracket
  (tag_name) @tag.section (#eq? @tag.section "section")
  ">" @tag.section.bracket))
((end_tag
  "</" @tag.section.bracket
  (tag_name) @tag.section (#eq? @tag.section "section")
  ">" @tag.section.bracket))

((start_tag
  "<" @tag.article.bracket
  (tag_name) @tag.article (#eq? @tag.article "article")
  ">" @tag.article.bracket))
((end_tag
  "</" @tag.article.bracket
  (tag_name) @tag.article (#eq? @tag.article "article")
  ">" @tag.article.bracket))

((start_tag
  "<" @tag.aside.bracket
  (tag_name) @tag.aside (#eq? @tag.aside "aside")
  ">" @tag.aside.bracket))
((end_tag
  "</" @tag.aside.bracket
  (tag_name) @tag.aside (#eq? @tag.aside "aside")
  ">" @tag.aside.bracket))

((start_tag
  "<" @tag.nav.bracket
  (tag_name) @tag.nav (#eq? @tag.nav "nav")
  ">" @tag.nav.bracket))
((end_tag
  "</" @tag.nav.bracket
  (tag_name) @tag.nav (#eq? @tag.nav "nav")
  ">" @tag.nav.bracket))

;; Links
((start_tag
  "<" @tag.a.bracket
  (tag_name) @tag.a (#eq? @tag.a "a")
  ">" @tag.a.bracket))
((end_tag
  "</" @tag.a.bracket
  (tag_name) @tag.a (#eq? @tag.a "a")
  ">" @tag.a.bracket))

((start_tag
  "<" @tag.link.bracket
  (tag_name) @tag.link (#eq? @tag.link "link")
  ">" @tag.link.bracket))

;; Text content
((start_tag
  "<" @tag.p.bracket
  (tag_name) @tag.p (#eq? @tag.p "p")
  ">" @tag.p.bracket))
((end_tag
  "</" @tag.p.bracket
  (tag_name) @tag.p (#eq? @tag.p "p")
  ">" @tag.p.bracket))

((start_tag
  "<" @tag.h1.bracket
  (tag_name) @tag.h1 (#eq? @tag.h1 "h1")
  ">" @tag.h1.bracket))
((end_tag
  "</" @tag.h1.bracket
  (tag_name) @tag.h1 (#eq? @tag.h1 "h1")
  ">" @tag.h1.bracket))

((start_tag
  "<" @tag.h2.bracket
  (tag_name) @tag.h2 (#eq? @tag.h2 "h2")
  ">" @tag.h2.bracket))
((end_tag
  "</" @tag.h2.bracket
  (tag_name) @tag.h2 (#eq? @tag.h2 "h2")
  ">" @tag.h2.bracket))

((start_tag
  "<" @tag.h3.bracket
  (tag_name) @tag.h3 (#eq? @tag.h3 "h3")
  ">" @tag.h3.bracket))
((end_tag
  "</" @tag.h3.bracket
  (tag_name) @tag.h3 (#eq? @tag.h3 "h3")
  ">" @tag.h3.bracket))

((start_tag
  "<" @tag.h4.bracket
  (tag_name) @tag.h4 (#eq? @tag.h4 "h4")
  ">" @tag.h4.bracket))
((end_tag
  "</" @tag.h4.bracket
  (tag_name) @tag.h4 (#eq? @tag.h4 "h4")
  ">" @tag.h4.bracket))

((start_tag
  "<" @tag.h5.bracket
  (tag_name) @tag.h5 (#eq? @tag.h5 "h5")
  ">" @tag.h5.bracket))
((end_tag
  "</" @tag.h5.bracket
  (tag_name) @tag.h5 (#eq? @tag.h5 "h5")
  ">" @tag.h5.bracket))

((start_tag
  "<" @tag.h6.bracket
  (tag_name) @tag.h6 (#eq? @tag.h6 "h6")
  ">" @tag.h6.bracket))
((end_tag
  "</" @tag.h6.bracket
  (tag_name) @tag.h6 (#eq? @tag.h6 "h6")
  ">" @tag.h6.bracket))

((start_tag
  "<" @tag.strong.bracket
  (tag_name) @tag.strong (#eq? @tag.strong "strong")
  ">" @tag.strong.bracket))
((end_tag
  "</" @tag.strong.bracket
  (tag_name) @tag.strong (#eq? @tag.strong "strong")
  ">" @tag.strong.bracket))

((start_tag
  "<" @tag.em.bracket
  (tag_name) @tag.em (#eq? @tag.em "em")
  ">" @tag.em.bracket))
((end_tag
  "</" @tag.em.bracket
  (tag_name) @tag.em (#eq? @tag.em "em")
  ">" @tag.em.bracket))

((start_tag
  "<" @tag.b.bracket
  (tag_name) @tag.b (#eq? @tag.b "b")
  ">" @tag.b.bracket))
((end_tag
  "</" @tag.b.bracket
  (tag_name) @tag.b (#eq? @tag.b "b")
  ">" @tag.b.bracket))

((start_tag
  "<" @tag.i.bracket
  (tag_name) @tag.i (#eq? @tag.i "i")
  ">" @tag.i.bracket))
((end_tag
  "</" @tag.i.bracket
  (tag_name) @tag.i (#eq? @tag.i "i")
  ">" @tag.i.bracket))

((start_tag
  "<" @tag.code.bracket
  (tag_name) @tag.code (#eq? @tag.code "code")
  ">" @tag.code.bracket))
((end_tag
  "</" @tag.code.bracket
  (tag_name) @tag.code (#eq? @tag.code "code")
  ">" @tag.code.bracket))

((start_tag
  "<" @tag.pre.bracket
  (tag_name) @tag.pre (#eq? @tag.pre "pre")
  ">" @tag.pre.bracket))
((end_tag
  "</" @tag.pre.bracket
  (tag_name) @tag.pre (#eq? @tag.pre "pre")
  ">" @tag.pre.bracket))

;; Lists
((start_tag
  "<" @tag.ul.bracket
  (tag_name) @tag.ul (#eq? @tag.ul "ul")
  ">" @tag.ul.bracket))
((end_tag
  "</" @tag.ul.bracket
  (tag_name) @tag.ul (#eq? @tag.ul "ul")
  ">" @tag.ul.bracket))

((start_tag
  "<" @tag.ol.bracket
  (tag_name) @tag.ol (#eq? @tag.ol "ol")
  ">" @tag.ol.bracket))
((end_tag
  "</" @tag.ol.bracket
  (tag_name) @tag.ol (#eq? @tag.ol "ol")
  ">" @tag.ol.bracket))

((start_tag
  "<" @tag.li.bracket
  (tag_name) @tag.li (#eq? @tag.li "li")
  ">" @tag.li.bracket))
((end_tag
  "</" @tag.li.bracket
  (tag_name) @tag.li (#eq? @tag.li "li")
  ">" @tag.li.bracket))

;; Tables
((start_tag
  "<" @tag.table.bracket
  (tag_name) @tag.table (#eq? @tag.table "table")
  ">" @tag.table.bracket))
((end_tag
  "</" @tag.table.bracket
  (tag_name) @tag.table (#eq? @tag.table "table")
  ">" @tag.table.bracket))

((start_tag
  "<" @tag.thead.bracket
  (tag_name) @tag.thead (#eq? @tag.thead "thead")
  ">" @tag.thead.bracket))
((end_tag
  "</" @tag.thead.bracket
  (tag_name) @tag.thead (#eq? @tag.thead "thead")
  ">" @tag.thead.bracket))

((start_tag
  "<" @tag.tbody.bracket
  (tag_name) @tag.tbody (#eq? @tag.tbody "tbody")
  ">" @tag.tbody.bracket))
((end_tag
  "</" @tag.tbody.bracket
  (tag_name) @tag.tbody (#eq? @tag.tbody "tbody")
  ">" @tag.tbody.bracket))

((start_tag
  "<" @tag.tr.bracket
  (tag_name) @tag.tr (#eq? @tag.tr "tr")
  ">" @tag.tr.bracket))
((end_tag
  "</" @tag.tr.bracket
  (tag_name) @tag.tr (#eq? @tag.tr "tr")
  ">" @tag.tr.bracket))

((start_tag
  "<" @tag.td.bracket
  (tag_name) @tag.td (#eq? @tag.td "td")
  ">" @tag.td.bracket))
((end_tag
  "</" @tag.td.bracket
  (tag_name) @tag.td (#eq? @tag.td "td")
  ">" @tag.td.bracket))

((start_tag
  "<" @tag.th.bracket
  (tag_name) @tag.th (#eq? @tag.th "th")
  ">" @tag.th.bracket))
((end_tag
  "</" @tag.th.bracket
  (tag_name) @tag.th (#eq? @tag.th "th")
  ">" @tag.th.bracket))

;; Forms
((start_tag
  "<" @tag.form.bracket
  (tag_name) @tag.form (#eq? @tag.form "form")
  ">" @tag.form.bracket))
((end_tag
  "</" @tag.form.bracket
  (tag_name) @tag.form (#eq? @tag.form "form")
  ">" @tag.form.bracket))

((start_tag
  "<" @tag.input.bracket
  (tag_name) @tag.input (#eq? @tag.input "input")
  ">" @tag.input.bracket))

((start_tag
  "<" @tag.button.bracket
  (tag_name) @tag.button (#eq? @tag.button "button")
  ">" @tag.button.bracket))
((end_tag
  "</" @tag.button.bracket
  (tag_name) @tag.button (#eq? @tag.button "button")
  ">" @tag.button.bracket))

((start_tag
  "<" @tag.select.bracket
  (tag_name) @tag.select (#eq? @tag.select "select")
  ">" @tag.select.bracket))
((end_tag
  "</" @tag.select.bracket
  (tag_name) @tag.select (#eq? @tag.select "select")
  ">" @tag.select.bracket))

((start_tag
  "<" @tag.option.bracket
  (tag_name) @tag.option (#eq? @tag.option "option")
  ">" @tag.option.bracket))
((end_tag
  "</" @tag.option.bracket
  (tag_name) @tag.option (#eq? @tag.option "option")
  ">" @tag.option.bracket))

((start_tag
  "<" @tag.textarea.bracket
  (tag_name) @tag.textarea (#eq? @tag.textarea "textarea")
  ">" @tag.textarea.bracket))
((end_tag
  "</" @tag.textarea.bracket
  (tag_name) @tag.textarea (#eq? @tag.textarea "textarea")
  ">" @tag.textarea.bracket))

((start_tag
  "<" @tag.label.bracket
  (tag_name) @tag.label (#eq? @tag.label "label")
  ">" @tag.label.bracket))
((end_tag
  "</" @tag.label.bracket
  (tag_name) @tag.label (#eq? @tag.label "label")
  ">" @tag.label.bracket))

;; Media
((start_tag
  "<" @tag.img.bracket
  (tag_name) @tag.img (#eq? @tag.img "img")
  ">" @tag.img.bracket))

((start_tag
  "<" @tag.video.bracket
  (tag_name) @tag.video (#eq? @tag.video "video")
  ">" @tag.video.bracket))
((end_tag
  "</" @tag.video.bracket
  (tag_name) @tag.video (#eq? @tag.video "video")
  ">" @tag.video.bracket))

((start_tag
  "<" @tag.audio.bracket
  (tag_name) @tag.audio (#eq? @tag.audio "audio")
  ">" @tag.audio.bracket))
((end_tag
  "</" @tag.audio.bracket
  (tag_name) @tag.audio (#eq? @tag.audio "audio")
  ">" @tag.audio.bracket))

((start_tag
  "<" @tag.source.bracket
  (tag_name) @tag.source (#eq? @tag.source "source")
  ">" @tag.source.bracket))

((start_tag
  "<" @tag.canvas.bracket
  (tag_name) @tag.canvas (#eq? @tag.canvas "canvas")
  ">" @tag.canvas.bracket))
((end_tag
  "</" @tag.canvas.bracket
  (tag_name) @tag.canvas (#eq? @tag.canvas "canvas")
  ">" @tag.canvas.bracket))

((start_tag
  "<" @tag.svg.bracket
  (tag_name) @tag.svg (#eq? @tag.svg "svg")
  ">" @tag.svg.bracket))
((end_tag
  "</" @tag.svg.bracket
  (tag_name) @tag.svg (#eq? @tag.svg "svg")
  ">" @tag.svg.bracket))

;; Scripts & Styles
((start_tag
  "<" @tag.script.bracket
  (tag_name) @tag.script (#eq? @tag.script "script")
  ">" @tag.script.bracket))
((end_tag
  "</" @tag.script.bracket
  (tag_name) @tag.script (#eq? @tag.script "script")
  ">" @tag.script.bracket))

((start_tag
  "<" @tag.noscript.bracket
  (tag_name) @tag.noscript (#eq? @tag.noscript "noscript")
  ">" @tag.noscript.bracket))
((end_tag
  "</" @tag.noscript.bracket
  (tag_name) @tag.noscript (#eq? @tag.noscript "noscript")
  ">" @tag.noscript.bracket))

((start_tag
  "<" @tag.style.bracket
  (tag_name) @tag.style (#eq? @tag.style "style")
  ">" @tag.style.bracket))
((end_tag
  "</" @tag.style.bracket
  (tag_name) @tag.style (#eq? @tag.style "style")
  ">" @tag.style.bracket))

;; Metadata
((start_tag
  "<" @tag.meta.bracket
  (tag_name) @tag.meta (#eq? @tag.meta "meta")
  ">" @tag.meta.bracket))

((start_tag
  "<" @tag.base.bracket
  (tag_name) @tag.base (#eq? @tag.base "base")
  ">" @tag.base.bracket))

;; Other common tags
((start_tag
  "<" @tag.br.bracket
  (tag_name) @tag.br (#eq? @tag.br "br")
  ">" @tag.br.bracket))

((start_tag
  "<" @tag.hr.bracket
  (tag_name) @tag.hr (#eq? @tag.hr "hr")
  ">" @tag.hr.bracket))

((start_tag
  "<" @tag.figcaption.bracket
  (tag_name) @tag.figcaption (#eq? @tag.figcaption "figcaption")
  ">" @tag.figcaption.bracket))
((end_tag
  "</" @tag.figcaption.bracket
  (tag_name) @tag.figcaption (#eq? @tag.figcaption "figcaption")
  ">" @tag.figcaption.bracket))

((start_tag
  "<" @tag.figure.bracket
  (tag_name) @tag.figure (#eq? @tag.figure "figure")
  ">" @tag.figure.bracket))
((end_tag
  "</" @tag.figure.bracket
  (tag_name) @tag.figure (#eq? @tag.figure "figure")
  ">" @tag.figure.bracket))

((start_tag
  "<" @tag.address.bracket
  (tag_name) @tag.address (#eq? @tag.address "address")
  ">" @tag.address.bracket))
((end_tag
  "</" @tag.address.bracket
  (tag_name) @tag.address (#eq? @tag.address "address")
  ">" @tag.address.bracket))
