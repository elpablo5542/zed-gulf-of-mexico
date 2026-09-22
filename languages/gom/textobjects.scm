(function_declaration
  body: (_) @function.inside) @function.around

(arrow_function
  body: (_) @function.inside) @function.around

(class_declaration
  body: (block (_)* @class.inside)) @class.around

(comment) @comment.around
