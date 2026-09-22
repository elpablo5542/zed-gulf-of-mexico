#!/usr/bin/env bash
# Prepares a copy of this extension for "zed: install dev extension".
#
# Installing straight from this directory works as-is. This script exists to
# try an unpublished grammar: if a checkout of tree-sitter-gom lives next to
# this repository (../tree-sitter-gom) or in $GOM_GRAMMAR_DIR and has a
# commit, the copy points at that checkout's HEAD through a file:// URL. Zed
# fetches grammars with git, so the changes must be committed there.
#
# Needs: git, and rustup (Zed compiles the extension to wasm32-wasip2 itself
# and installs that target through rustup).
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="${GOM_ZED_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/gulf-of-mexico}"
ext="$out/zed-extension"
grammar_dir="${GOM_GRAMMAR_DIR:-$here/../tree-sitter-gom}"

# Copy the extension. Zed's build products (grammars/, extension.wasm,
# target/) are kept so reinstalling is fast.
mkdir -p "$ext"
for f in extension.toml Cargo.toml src languages snippets README.md LICENSE; do
   rm -rf "$ext/$f"
   cp -R "$here/$f" "$ext/$f"
done

grammar_note="the grammar commit pinned in extension.toml (GitHub)"
if rev="$(git -C "$grammar_dir" rev-parse HEAD 2>/dev/null)"; then
   grammar_dir="$(cd "$grammar_dir" && pwd)"
   python3 - "$ext/extension.toml" "$grammar_dir" "$rev" <<'PY'
import re, sys
path, repo, rev = sys.argv[1:]
t = open(path).read()
t = re.sub(r'(\[grammars\.gom\]\nrepository = )"[^"]*"', r'\1"file://%s"' % repo, t)
t = re.sub(r'(\[grammars\.gom\]\nrepository = "[^"]*"\nrev = )"[^"]*"', r'\1"%s"' % rev, t)
open(path, 'w').write(t)
PY
   grammar_note="the local grammar checkout $grammar_dir at commit ${rev:0:12}"
elif grep -q 'rev = "GRAMMAR_REV"' "$ext/extension.toml"; then
   echo "extension.toml still has the placeholder rev and no local grammar checkout was found." >&2
   echo "Pin a commit of https://github.com/elpablo5542/tree-sitter-gom in extension.toml," >&2
   echo "or set GOM_GRAMMAR_DIR to a checkout with at least one commit." >&2
   exit 1
fi

cat <<MSG
Extension prepared in:
   $ext
using $grammar_note.

In Zed, run "zed: install dev extension" and pick that directory. The
language server needs the interpreter: put gom on your PATH (built with
"zig build" in GOM-Interpreter), or set it in settings.json:
   "lsp": { "gom": { "binary": { "path": "/path/to/gom", "arguments": ["--lsp"] } } }
MSG
