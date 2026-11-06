# Neovim 0.12 maintenance guide

This configuration requires Neovim 0.12 or newer. These notes describe its current
API choices, verified against Neovim 0.12.6 and the committed plugin revisions.
They replace the speculative pre-release migration checklist.

## Native LSP configuration

`nvim-lspconfig` supplies server definitions. `vim.lsp.config()` merges local
overrides into those definitions, and `vim.lsp.enable()` enables the selected
servers. These components are intended to work together; replacing the server
definitions with local copies is unnecessary.

`on_attach` is a supported native client option. Use it for server-specific
behavior, such as the buffer-local Ruff commands. Use a shared `LspAttach`
autocmd for mappings and behavior common to several servers. Svelte's upstream
configuration already supplies its JS/TS save notification hook.

Native `commands` maps LSP command names to client-side handler functions. It
is not the old lspconfig mechanism for defining Ex commands. Register Ex commands
with `nvim_create_user_command()` or `nvim_buf_create_user_command()`.

Reference highlighting installs one set of autocmds per buffer. A client detach
must preserve those callbacks while another supporting client remains attached.
A buffer-local inlay-hint toggle passes `{ bufnr = ... }` to both
`vim.lsp.inlay_hint.is_enabled()` and `vim.lsp.inlay_hint.enable()`.

## Diagnostics and options

Use `vim.diagnostic.jump()` for diagnostic navigation and configure sign text
through `vim.diagnostic.config()`. Avoid relying on assumptions about which old
APIs have been removed; consult the installed help when updating.

Both floating-window borders and popup-menu borders use string values here:

```lua
vim.opt.winborder = 'rounded'
vim.opt.pumborder = 'rounded'
```

`pumborder = true` is not valid. Version validation runs before these options are
set, and `:checkhealth plugins` checks the same minimum version.

## Tree-sitter and completion

The pinned Tree-sitter `main` API installs parsers with
`require('nvim-treesitter').install(...)`. Highlighting starts through
`vim.treesitter.start()` on `FileType`, and indentation uses the plugin's
`indentexpr()`. Tree-sitter itself is loaded eagerly as required by this API.
The CLI executable check compares `vim.fn.executable()` with `0`: Lua treats
numeric zero as truthy.

Blink supplies completion capabilities through the wildcard LSP configuration.
Lazydev is explicitly initialized. Standard snippets use Neovim's native snippet
engine and friendly-snippets; LuaSnip is not required by this configuration.

## Formatting, themes, and updates

Conform uses `lsp_format = 'fallback'` or `'never'` rather than the compatibility
`lsp_fallback` option. Shell scripts normally have filetype `sh`, so shfmt is
registered for both `sh` and `bash`.

The theme switcher is the single startup theme-selection path. Lualine handles
its own `ColorScheme`/background refresh. Canceling a preview restores both the
previous colorscheme and background setting.

After a plugin or Neovim update, run the checks documented in the README and
review `:checkhealth`. Commit the updated lockfile once verified. Optional GUI
plugins use Lazy's `cond` mechanism so their pins survive terminal-mode updates.

## References

- [Neovim LSP documentation](https://neovim.io/doc/user/lsp/)
- [Neovim options documentation](https://neovim.io/doc/user/options/)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [Tree-sitter main API](https://github.com/nvim-treesitter/nvim-treesitter/tree/main)
- [Blink snippets](https://cmp.saghen.dev/configuration/snippets)
