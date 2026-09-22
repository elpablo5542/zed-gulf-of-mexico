# Gulf of Mexico for Zed

Syntax highlighting, snippets, and a language server for
[Gulf of Mexico](https://github.com/TodePond/GulfOfMexico) (formerly
DreamBerd) `.gom` files in the [Zed](https://zed.dev) editor.

- **Highlighting** comes from the
  [tree-sitter-gom](https://github.com/elpablo5542/tree-sitter-gom) grammar.
  It understands every spelling of `function`, the five declaration forms,
  lifetimes, type annotations, `!`/`?`/`¡` terminators, `;` as not, `=`
  through `====`, quote runs of any length (including unclosed ones), all five
  interpolation currencies, `=====` file separators, number words, calls with
  or without parentheses, and DBX elements.
- **Snippets**: `cc`, `cv`, `vc`, `vv`, `ccc`, `life`, `fn`, `fne`, `afn`,
  `arrow`, `if`, `ifn`, `else`, `when`, `class`, `new`, `print`, `dbg`, `ret`,
  `del`, `rev`, `sig`, `file`, `exp`, `imp`, `interp`, `next`, `prev`, `on`,
  `noop`, `dbx`. Type one and press Tab.
- **Completion and diagnostics** come from `gom --lsp`, the language server
  built into the [GOM-Interpreter](https://github.com/elpablo5542/GOM-Interpreter).
- Bracket matching, 3-space indentation, comment toggling, an outline of
  functions, classes, declarations and files, and vim text objects.

## Install

Until the extension is in Zed's registry, install it as a dev extension. Zed
builds extensions itself, so [rustup](https://rustup.rs) must be on your PATH
(Zed adds the `wasm32-wasip2` target through it).

1. Clone this repository.
2. In Zed, run `zed: install dev extension` and pick the clone. The first
   build downloads wasi-sdk and compiles the grammar and the extension.
3. Open a `.gom` file.

## Language server

The extension starts `gom --lsp`. Build the interpreter with `zig build` in
[GOM-Interpreter](https://github.com/elpablo5542/GOM-Interpreter) and put
`zig-out/bin/gom` on your PATH. When the open project is the interpreter
repository itself, `zig-out/bin/gom` is found without that. To use a binary
somewhere else, set it in Zed's `settings.json`:

```json
{
  "lsp": {
    "gom": {
      "binary": { "path": "/absolute/path/to/gom", "arguments": ["--lsp"] }
    }
  }
}
```

## Working on the grammar

[`extension.toml`](extension.toml) pins a commit of tree-sitter-gom. To try
grammar changes before pushing them, clone the grammar next to this repository
(`../tree-sitter-gom`, or point `GOM_GRAMMAR_DIR` at it), commit there, and run

```sh
./dev-install.sh
```

It copies the extension to `~/.local/share/gulf-of-mexico/zed-extension` with
the grammar pointed at that checkout's HEAD (Zed only fetches grammars through
git). Install that directory as the dev extension. After pushing the grammar,
pin the new commit here (run from the grammar checkout):

```sh
sed -i "s/^rev = .*/rev = \"$(git rev-parse HEAD)\"/" ../zed-gulf-of-mexico/extension.toml
```

## Publishing

Follow [Zed's extension docs](https://zed.dev/docs/extensions/developing-extensions#publishing-your-extension):
open a pull request to `zed-industries/extensions` that adds this repository
as a submodule and lists it in `extensions.toml`.

## Layout

```
extension.toml            manifest: grammar, language server, snippets
Cargo.toml, src/lib.rs    tells Zed how to start `gom --lsp`
languages/gom/config.toml file suffixes, comments, brackets, 3-space indents
languages/gom/*.scm       highlights, brackets, indents, outline, overrides, textobjects
snippets/gulf of mexico.json
dev-install.sh            dev install with a local grammar checkout
```

## License

GPL-3.0-or-later, like the interpreter. See [LICENSE](LICENSE).
