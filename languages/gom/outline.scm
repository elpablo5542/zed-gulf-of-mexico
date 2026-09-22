(file_separator) @name @item

(function_declaration
  "async"? @context
  keyword: (function_keyword) @context
  name: (_) @name) @item

(class_declaration
  "class" @context
  name: (identifier) @name) @item

(class_declaration
  "className" @context
  name: (identifier) @name) @item

(declaration
  kind: (declaration_keywords) @context
  name: (_) @name) @item
