//! Zed extension for Gulf of Mexico.
//!
//! Syntax highlighting comes from the tree-sitter grammar declared in
//! extension.toml (github.com/elpablo5542/tree-sitter-gom); this crate only
//! tells Zed how to start the language server, which is the interpreter
//! itself: `gom --lsp` (github.com/elpablo5542/GOM-Interpreter).

use zed_extension_api::{self as zed, LanguageServerId, Result};

struct GulfOfMexicoExtension;

impl GulfOfMexicoExtension {
    /// Finds the `gom` binary: on PATH, or built in the worktree
    /// (`zig-out/bin/gom` when the open project is the interpreter itself).
    fn gom_path(&self, worktree: &zed::Worktree) -> Result<String> {
        if let Some(path) = worktree.which("gom") {
            return Ok(path);
        }
        let is_interpreter_repo = worktree
            .read_text_file("build.zig")
            .map(|build| build.contains("\"gom\""))
            .unwrap_or(false);
        if is_interpreter_repo {
            return Ok(format!("{}/zig-out/bin/gom", worktree.root_path()));
        }
        Err(concat!(
            "gom not found. Build the interpreter with `zig build` and put zig-out/bin/gom on your PATH, ",
            "or set the path in Zed's settings:\n",
            "\"lsp\": { \"gom\": { \"binary\": { \"path\": \"/path/to/gom\", \"arguments\": [\"--lsp\"] } } }"
        )
        .to_string())
    }
}

impl zed::Extension for GulfOfMexicoExtension {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        _language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        Ok(zed::Command {
            command: self.gom_path(worktree)?,
            args: vec!["--lsp".to_string()],
            env: Default::default(),
        })
    }
}

zed::register_extension!(GulfOfMexicoExtension);
