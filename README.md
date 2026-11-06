# Neovim configuration

A personal, modular configuration derived from kickstart.nvim. It favors fuzzy
search, structural editing, and project-provided tools. `init.lua` is the explicit
plugin manifest; files under `lua/plugins/` are loaded only when imported there
or declared as dependencies.

## Requirements and installation

Neovim **0.12 or newer** is required. The audit checks were run with 0.12.6.
Check `nvim --version` before using a distribution package.

Install Git, ripgrep (`rg`), `make`, a C compiler, and `tree-sitter` for plugin and
parser builds. A Nerd Font is expected. `fd` is optional. Yazi, LazyGit, and Claude
Code need their respective executables when invoked.

Back up an existing configuration before cloning:

```sh
git clone https://github.com/obazin/nvim-config.git ~/.config/nvim
```

Launch Neovim, let Lazy install the plugins, then run `:Lazy restore` to reproduce
the committed `lazy-lock.json`. Use `:Lazy update` deliberately and commit the
resulting lockfile after verification. ToggleTerm's pin is retained even when
updating from a terminal session; it only loads under Neovide.

Run `:checkhealth plugins` for configuration prerequisites and `:checkhealth` for
plugin-specific checks. Tree-sitter installs the requested missing parsers;
`:TSUpdate` updates them after a plugin update.

## Project tools

Language servers, formatters, and debug adapters come from each project's
`nix develop` shell or another environment exposing them on `PATH`. Start Neovim
inside that environment. This repository's flake supplies `lua-language-server`
and `stylua` for working on the configuration itself; it is not a complete IDE
toolchain for every language.

- Lua: LuaLS and StyLua, with Lazydev supplying Neovim/plugin libraries.
- Python: Pyright for types, Ruff for linting and formatting. Interpreter discovery
  checks a usable activated virtualenv, project-local virtualenvs, then Python on
  `PATH`; otherwise Pyright handles discovery.
- Shell: bash-language-server and shfmt. Both `sh` and `bash` buffers select shfmt.
- Web languages: the configured HTML, CSS, Emmet, Svelte, VTSLS, and Tailwind servers.
- Rust: rustaceanvim manages rust-analyzer and Rust debugging. Expose a compatible
  CodeLLDB/liblldb installation through the project environment or Nix profile.
- Docker/Compose and Typst: their configured servers must also be available.

Conform formats on save, using LSP fallback except for C/C++. `<M-f>` requests
formatting explicitly. `:ConformInfo` shows formatter availability and failures.
Ruff attaches buffer-local `:RuffAutofix` and `:RuffOrganizeImports` commands.

## Interfaces and editing

| Purpose | Interface |
|---|---|
| Files, text, buffers, references | Telescope |
| Fast positional jumps | Flash |
| Document outline | Aerial (`<leader>o`) |
| Diagnostics, references, quickfix/location lists | Trouble |
| Persistent file tree and Git status tree | Neo-tree |
| Terminal file-management workflow | Yazi |
| Git signs, full-file blame, interactive Git | Gitsigns, blame.nvim, LazyGit |
| Completion and snippets | Blink, native `vim.snippet`, friendly-snippets |
| Textobjects and surroundings | Tree-sitter textobjects, Mini AI/Surround |
| Comment lines or selections | Native `gcc` / `gc` |
| Folds and folded-content preview | UFO (`zR`, `zM`, `zK`) |
| Debugging | nvim-dap and dap-ui, with Rust integration |
| AI terminal and diffs | claudecode.nvim |

Neo-tree and Yazi are retained for their distinct tree and terminal workflows.
UFO is retained for folded-content preview. Aerial owns the outline shortcut;
Trouble handles diagnostic and result lists. Themes remain available on startup
so the theme picker can enumerate them, while shared Blink/Telescope startup
requirements are explicit in their specs.

The dashboard handles an empty launch. A single directory argument becomes the
working directory and opens its dashboard. Files and piped stdin remain visible.
Neovide overrides run after general options, and dashboard visibility is
configured without forcing statuslines on every window event.

## Key mappings

The leader is Space. Use `<leader>sk` to inspect mappings.

| Keys | Action |
|---|---|
| `jj` / `jk` in Insert mode | Return to Normal mode without saving |
| `<leader>ww` | Save the current buffer if modified |
| `<leader>sf` / `<leader>sg` | Find files / grep |
| `<leader>sm` | Files by modification time |
| `<leader>st` | Notes by frontmatter tags |
| `<leader>sx…` | Swap syntax objects; see the textobject reference |
| `al` / `il` | Around/inside a Tree-sitter loop |
| `s` / `S` | Flash jump / Tree-sitter jump |
| `gsa` / `gsd` / `gsr` | Add / delete / replace surroundings |
| `<leader>th` | Toggle inlay hints in the current buffer |
| `<leader>ut` | Preview, select, and persist a colorscheme |
| `<leader>lf` / `<leader>ngs` | Neo-tree files / Git status |
| `<leader>-` / `<leader>f` | Yazi at the current file / working directory |
| `<leader>o` | Toggle the document outline |
| `{` / `}` in Aerial-supported buffers | Previous / next document symbol |

Full structural mappings are in [textobjects-keybindings.md](textobjects-keybindings.md).
The [training guide](neovim-training.md) introduces the underlying editing model.

## Notes and custom pickers

The notes picker finds the nearest `.notes` or `.obsidian` marker above the
current file, then reads Markdown frontmatter. A top-level `tags:` key accepts
plain or quoted strings in a one-line `[a, b]` list, a block list, or a
space/comma-separated scalar. Double-quoted strings use JSON-style escapes.
Comments are ignored and duplicate tags count once per note. YAML aliases,
mappings, multiline strings, and multiline flow lists are unsupported and
reported instead of guessed. Frontmatter is read through its closing delimiter,
without a 4 KB cutoff. Select multiple tags with Tab for AND filtering.

Both custom file pickers scan in an isolated Neovim worker process, keeping file
reads and sorting off the editor thread. They honor ripgrep ignore rules, report
scan errors, cancel superseded requests, and discard results if you switch
buffers or directories before completion.

## Verification and maintenance

After installing/restoring the locked plugins, run from this repository:

```sh
bash tests/run.sh
stylua --check init.lua lua tests
```

The regression suite uses temporary state/cache directories, exercises actual
Telescope picker flows, and starts the full configuration in terminal and
simulated Neovide modes. It disables parser downloads and Claude's listening
service during startup checks. It does not launch a graphical Neovide session or
exercise external debug adapters. Individual checks can be run with, for example,
`bash tests/run.sh tests/lsp_test.lua`.

Keep imports in `init.lua`, configure only deliberate deviations from plugin
defaults, and update the lockfile alongside plugin changes. See the
[0.12 maintenance guide](NVIM_0.12_MIGRATION_GUIDE.md) for the native APIs used here.

## Credits

Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), with thanks
to its authors and the authors of the included plugins.
