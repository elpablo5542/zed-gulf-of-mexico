; Gulf of Mexico highlighting for Zed.
; Later patterns win, so the general ones come first.

; ---------------------------------------------------------------- basics

(comment) @comment
(identifier) @variable
(number) @number
(boolean) @boolean
(undefined) @constant.builtin
(terminator) @keyword
(paren) @punctuation.bracket
(empty_parens) @punctuation.bracket

; Strings: any run of quotes opens one, the mirrored run closes it.
(string) @string
(string_start) @string
(string_end) @string
(string_content) @string

; Interpolation: use your regional currency.
(interpolation_open) @string.escape
(interpolation_close) @string.escape
(interpolation (identifier) @variable)

; A `=====` line starts a new file.
(file_separator) @title

; ------------------------------------------------------------- keywords

(declaration_keywords) @keyword

[
  "if"
  "else"
  "when"
  "return"
  "delete"
  "reverse"
  "export"
  "to"
  "import"
  "await"
  "async"
  "new"
  "previous"
  "current"
  "next"
  "class"
  "className"
] @keyword

; Any ordered subsequence of the letters of "function" declares a function.
((function_keyword) @keyword
  (#match? @keyword "^f?u?n?c?t?i?o?n?$"))

; `noop!` takes up a line.
((identifier) @keyword
  (#eq? @keyword "noop"))

; ------------------------------------------------------------ constants

[
  (lifetime)
] @constant

(lifetime (number) @constant)
(lifetime (identifier) @constant)

((identifier) @constant.builtin
  (#any-of? @constant.builtin "Infinity" "NaN"))

; Numbers by name
((identifier) @number
  (#any-of? @number
    "zero" "one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten"
    "eleven" "twelve" "thirteen" "fourteen" "fifteen" "sixteen" "seventeen"
    "eighteen" "nineteen" "twenty" "thirty" "forty" "fifty" "sixty" "seventy"
    "eighty" "ninety" "hundred" "thousand" "million"))

; ---------------------------------------------------------------- types

(type (identifier) @type)
(type_argument) @type
(type "[]" @punctuation.bracket)
(type_annotation ":" @punctuation.delimiter)

((type (identifier) @type.builtin)
  (#any-of? @type.builtin "Int" "Int9" "Int99" "String" "Char" "Digit" "Bool" "Float" "RegExp" "Regex"))

; --------------------------------------------------- functions & classes

(function_declaration
  name: (identifier) @function)

(parameter
  name: (identifier) @variable.special)

(bare_call
  function: (identifier) @function)

(bare_call
  function: (member_expression
    property: (property_identifier) @function.method))

(call_expression
  function: (identifier) @function)

(call_expression
  function: (member_expression
    property: (property_identifier) @function.method))

((bare_call function: (identifier) @function.builtin)
  (#any-of? @function.builtin "print" "use" "addEventListener" "requestAnimationFrame"))

((call_expression function: (identifier) @function.builtin)
  (#any-of? @function.builtin "print" "use" "addEventListener" "requestAnimationFrame"))

(class_declaration
  name: (identifier) @type)

(new_expression
  class: (identifier) @type)

((member_expression
  object: (identifier) @type)
  (#eq? @type "Date"))

; ---------------------------------------------------------- properties

(member_expression
  property: (property_identifier) @property)

(pair
  key: (property_identifier) @property)

(declaration
  name: (identifier) @variable)

(declaration
  name: (number) @variable)

(export_statement
  name: (identifier) @variable)

(import_statement
  name: (identifier) @variable)

(time_travel_expression
  name: (identifier) @variable)

; ------------------------------------------------------------ operators

[
  "="
  "=="
  "==="
  "===="
  "+="
  "-="
  "*="
  "/="
  "<"
  ">"
  "<="
  ">="
  "+"
  "-"
  "*"
  "/"
  "^"
  "++"
  "--"
  "&&"
  "||"
  ";"
  "=>"
] @operator

(lifetime "<" @constant)
(lifetime ">" @constant)
(lifetime "-" @constant)

[
  "{"
  "}"
  "["
  "]"
] @punctuation.bracket

[
  ","
  "."
] @punctuation.delimiter

(pair ":" @punctuation.delimiter)

; ------------------------------------------------------------------ DBX

(dbx_open_tag
  name: (dbx_tag_name) @tag)
(dbx_close_tag
  name: (dbx_tag_name) @tag)
(dbx_self_closing_tag
  name: (dbx_tag_name) @tag)

(dbx_attribute
  name: (dbx_attribute_name) @attribute)

; `class` is forbidden in DBX; use `htmlClassName`.
((dbx_attribute_name) @keyword
  (#any-of? @keyword "class" "className"))

(dbx_text) @string.special

(dbx_open_tag ["<" ">"] @punctuation.bracket)
(dbx_close_tag ["</" ">"] @punctuation.bracket)
(dbx_self_closing_tag ["<" "/>"] @punctuation.bracket)
(dbx_attribute "=" @operator)
(dbx_expression ["{" "}"] @punctuation.special)

; Rich text names: `const const <b>title</b> = "Bold"!`
(declaration
  name: (dbx_element (dbx_text) @emphasis.strong))
