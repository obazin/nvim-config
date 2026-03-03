# Neovim 0.12 Migration Guide

> **Target release**: ~March 14, 2026
> **Migrating from**: Neovim 0.10/0.11

---

## Table of Contents

1. [Breaking Changes](#1-breaking-changes)
2. [Removed Features](#2-removed-features-previously-deprecated)
3. [Deprecations to Update](#3-deprecations-to-update)
4. [New Best Practices](#4-new-best-practices)
5. [New Features Worth Adopting](#5-new-features-worth-adopting)
6. [Step-by-Step Migration Checklist](#6-step-by-step-migration-checklist)

---

## 1. Breaking Changes

### 1.1 `vim.diff` moved to `vim.text.diff`

```lua
-- OLD:
local result = vim.diff(str_a, str_b)

-- NEW:
local result = vim.text.diff(str_a, str_b)
```

### 1.2 `vim.treesitter.get_parser()` now returns `nil` instead of raising an error

Any code that assumed `get_parser()` always returns a value (or used `pcall` to handle errors) must now handle `nil`.

```lua
-- OLD:
local parser = vim.treesitter.get_parser(bufnr, lang)
parser:parse()

-- NEW:
local parser = vim.treesitter.get_parser(bufnr, lang)
if parser then
  parser:parse()
end
```

**Impact**: This affects many plugins (mini.nvim, vscode-neovim, etc.). Check your custom treesitter code.

### 1.3 `i_CTRL-R` inserts registers literally

In insert mode, `CTRL-R` now inserts register contents literally (like a paste) instead of simulating typing character by character. This is ~10x faster but **no longer triggers abbreviations or insert-mode mappings**.

### 1.4 `'shelltemp'` defaults to `false`

Shell commands (`:grep`, `:make`, etc.) now use `pipe()` instead of temp files. If you need the old behavior:

```lua
vim.opt.shelltemp = true
```

### 1.5 `'exrc'` trust model changed

Project-local exrc files no longer offer an `(a)llow` interactive choice. You must explicitly `:trust` a file. Exrc files are also now loaded from parent directories.

### 1.6 LSP JSON `null` values represented as `vim.NIL`

```lua
-- Previously null values were Lua nil (invisible in tables)
-- Now they are vim.NIL (a sentinel value)
if value == vim.NIL then
  -- handle null
end
```

### 1.7 `'pumblend'` foreground layer change

`'pumblend'` no longer applies special attributes to the foreground layer of the popup menu. Some colorscheme appearances may change.

### 1.8 Buffer name URI parsing follows RFC 3986

May affect plugins that use custom URI schemes for buffer names.

### 1.9 `ui-messages` event changes

- `"msg_show.return_prompt"` and `"msg_history_clear"` no longer emitted
- `msg_clear` event repurposed (now emits after screen clear)
- `msg_show` gains `append` and `msg_id` parameters

**Impact**: Custom UIs or plugins like **noice.nvim** may need updates.

### 1.10 `'spellfile'` default location changed

Default is now `stdpath("data").."/site/spell/"` instead of the first writable runtimepath directory.

### 1.11 Windows: no longer searches current directory for executables

Use explicit paths instead.

---

## 2. Removed Features (Previously Deprecated)

These were deprecated in 0.10 or earlier and are **now fully removed**.

### 2.1 `vim.diagnostic.disable()` and `vim.diagnostic.is_disabled()` — REMOVED

```lua
-- OLD (removed):
vim.diagnostic.disable(bufnr)
vim.diagnostic.is_disabled(bufnr)

-- NEW:
vim.diagnostic.enable(false, { bufnr = bufnr })
not vim.diagnostic.is_enabled({ bufnr = bufnr })
```

### 2.2 Legacy `vim.diagnostic.enable(bufnr, ns)` positional signature — REMOVED

```lua
-- OLD (removed):
vim.diagnostic.enable(bufnr, namespace)

-- NEW:
vim.diagnostic.enable(true, { bufnr = bufnr, ns_id = namespace })
```

### 2.3 `sign_define()` for diagnostic signs — REMOVED

```lua
-- OLD (removed):
vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn',  { text = '', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignHint',  { text = '', texthl = 'DiagnosticSignHint' })
vim.fn.sign_define('DiagnosticSignInfo',  { text = '', texthl = 'DiagnosticSignInfo' })

-- NEW:
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN]  = '',
      [vim.diagnostic.severity.HINT]  = '',
      [vim.diagnostic.severity.INFO]  = '',
    },
  },
})
```

### 2.4 `vim.lsp.semantic_tokens.start()/stop()` — REMOVED

```lua
-- OLD (removed):
vim.lsp.semantic_tokens.start(bufnr, client_id)
vim.lsp.semantic_tokens.stop(bufnr, client_id)

-- NEW:
vim.lsp.semantic_tokens.enable(true, { bufnr = bufnr })
vim.lsp.semantic_tokens.enable(false, { bufnr = bufnr })
```

### 2.5 Other removals

| Removed | Replacement |
|---------|-------------|
| `complete_match()` | Removed entirely |
| `'completefuzzycollect'` option | Removed entirely |
| `'isexpand'` option | Removed entirely |
| `shellmenu` plugin | Removed entirely |
| `--server` CLI flag | Use `--connect` instead |

---

## 3. Deprecations to Update

These still work in 0.12 but **will be removed in a future release**. Update them now.

### 3.1 LSP functions

| Deprecated | Replacement |
|------------|-------------|
| `vim.lsp.stop_client(client)` | `client:stop()` |
| `vim.lsp.buf_get_clients()` | `vim.lsp.get_clients({ buffer = bufnr })` |
| `vim.lsp.get_buffers_by_client_id(id)` | `vim.lsp.get_client_by_id(id).attached_buffers` |
| `vim.lsp.set_log_level()` | `vim.lsp.log.set_level()` |
| `vim.lsp.get_log_path()` | `vim.lsp.log.get_filename()` |
| `vim.lsp.buf.server_ready()` | Use `LspAttach` autocmd |
| `vim.lsp.buf.range_code_action()` | `vim.lsp.buf.code_action({ range = ... })` |
| `vim.lsp.util.stylize_markdown()` | `vim.treesitter.start()` with `vim.wo.conceallevel = 2` |

### 3.2 Diagnostic options

```lua
-- DEPRECATED: "float" key in jump opts
vim.diagnostic.config({
  jump = { float = true },
})

-- NEW: use "on_jump" callback
vim.diagnostic.config({
  jump = {
    on_jump = function(diagnostic)
      vim.diagnostic.open_float()
    end,
  },
})
```

| Deprecated | Replacement |
|------------|-------------|
| `vim.diagnostic.get_next_pos()` | `lnum`/`col` from `vim.diagnostic.get_next()` |
| `vim.diagnostic.get_prev_pos()` | `lnum`/`col` from `vim.diagnostic.get_prev()` |

### 3.3 Treesitter

| Deprecated | Replacement |
|------------|-------------|
| `LanguageTree:for_each_child()` | `LanguageTree:children()` |

### 3.4 Highlight

| Deprecated | Replacement |
|------------|-------------|
| `:ownsyntax` / `w:current_syntax` | `'winhighlight'` option |

### 3.5 CodeLens API

The codelens API has been reimplemented. It now renders as **virtual lines** instead of virtual text.

```lua
-- DEPRECATED:
vim.lsp.codelens.refresh()
vim.lsp.codelens.clear()
vim.lsp.codelens.display()

-- NEW:
vim.lsp.codelens.enable(true)   -- replaces refresh + display
vim.lsp.codelens.enable(false)  -- replaces clear
```

---

## 4. New Best Practices

### 4.1 Native LSP configuration (replaces nvim-lspconfig for simple setups)

Since 0.11, Neovim supports native LSP configuration with `vim.lsp.config()` and `vim.lsp.enable()`. In 0.12 this is the fully recommended approach.

**Step 1**: Create config files in `~/.config/nvim/lsp/`:

```lua
-- ~/.config/nvim/lsp/lua_ls.lua
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.stylua.toml' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
}
```

**Step 2**: Enable servers in your init.lua:

```lua
-- Global defaults for all servers:
vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = { multilineTokenTypes = true },
    },
  },
})

-- Enable servers (auto-discovered from lsp/ directory):
vim.lsp.enable({ 'lua_ls', 'rust_analyzer', 'pyright', 'ts_ls' })
```

> **Note**: nvim-lspconfig still works and acts as a configuration registry. You don't _have_ to migrate away from it, but native config is simpler for straightforward setups.

### 4.2 Modern diagnostic configuration

```lua
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = '●',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN]  = '',
      [vim.diagnostic.severity.HINT]  = '',
      [vim.diagnostic.severity.INFO]  = '',
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  jump = {
    on_jump = function()
      vim.diagnostic.open_float()
    end,
  },
})

-- Toggle diagnostics the modern way:
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggle diagnostics' })
```

### 4.3 Use `vim.lsp.enable()` over `on_attach` patterns

```lua
-- OLD pattern:
local on_attach = function(client, bufnr)
  -- keymaps, formatting, etc.
end
require('lspconfig').lua_ls.setup({ on_attach = on_attach })

-- NEW pattern (0.12):
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    -- keymaps, formatting, etc.
  end,
})
vim.lsp.enable({ 'lua_ls' })
```

---

## 5. New Features Worth Adopting

### 5.1 Native autocomplete (`'autocomplete'` option)

```lua
vim.opt.autocomplete = 'menu,menuone,noselect'

-- Combine with LSP completion:
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = true,
      })
    end
  end,
})
```

### 5.2 Native plugin manager (`vim.pack`)

```lua
vim.pack.add({
  'nvim-treesitter/nvim-treesitter',
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/stevearc/conform.nvim', version = 'main' },
})

-- Update:  :lua vim.pack.update()
-- Delete:  :lua vim.pack.del('plugin-name')
```

> **Note**: `vim.pack` has **no lazy loading**. For complex configs with many plugins, lazy.nvim remains the better choice.

### 5.3 Built-in HTTP requests

```lua
local response = vim.net.request('https://api.example.com/data')
```

### 5.4 New built-in commands

| Command | Description |
|---------|-------------|
| `:Undotree` | Visual undo tree navigator (replaces undotree plugin) |
| `:DiffTool` | Directory and file comparison tool |
| `:restart` | Restarts Nvim and reattaches the UI |
| `:connect` | Dynamically connects a UI to a Neovim server |
| `:wall ++p` | Write all buffers, creating parent directories if needed |

### 5.5 Window and popup borders

```lua
-- Add border to popup menu:
vim.opt.pumborder = true

-- Global floating window border style:
vim.opt.winborder = 'rounded'  -- 'single', 'double', 'bold', etc.
```

### 5.6 New highlight groups

| Highlight Group | Purpose |
|-----------------|---------|
| `DiffTextAdd` | Added text in changed diff lines |
| `OkMsg` | OK/success messages |
| `StderrMsg` | Stderr output |
| `StdoutMsg` | Stdout output |
| `SnippetTabstopActive` | Active snippet tabstop |
| `PmenuBorder` | Popup menu border |
| `PmenuShadow` | Popup menu shadow |

### 5.7 New default keymaps

| Keymap | Action |
|--------|--------|
| `grt` | `vim.lsp.buf.type_definition()` |

### 5.8 Enhanced `vim.tbl_deep_extend()`

```lua
-- Accept a function for custom merge logic:
vim.tbl_deep_extend(function(key, left, right)
  return right  -- custom per-key merge
end, table_a, table_b)
```

### 5.9 Enhanced `vim.json`

```lua
-- Pretty-print JSON:
vim.json.encode(data, { indent = 2, sort_keys = true })

-- Parse JSON with comments (JSONC):
vim.json.decode(str, { skip_comments = true })
```

### 5.10 `vim.fs.root()` with priority groups

```lua
-- Nested lists for equal priority root markers:
vim.fs.root(0, { { '.git', 'Makefile' }, 'package.json' })
```

### 5.11 `gx` uses LSP `textDocument/documentLink`

When an LSP server provides document links, `gx` will use those instead of generic URL detection.

### 5.12 Treesitter markdown highlighting enabled by default

No more need for nvim-treesitter to enable Markdown highlighting — it works out of the box.

### 5.13 Improved `'diffopt'` defaults

`'diffopt'` now includes `"indent-heuristic"` and `"inline:char"` by default for better diff display.

### 5.14 `'smartcase'` applies to completion filtering

The `'smartcase'` option now also affects how completion items are filtered, not just search.

### 5.15 `vim.wait()` returns callback results

```lua
local result = vim.wait(1000, function()
  return some_condition() and some_value
end)
```

---

## 6. Step-by-Step Migration Checklist

Follow these steps to migrate your config to Neovim 0.12:

### Step 1: Fix breaking changes (required)

- [ ] Replace `vim.diff()` with `vim.text.diff()`
- [ ] Add `nil` checks after every `vim.treesitter.get_parser()` call
- [ ] Remove `vim.diagnostic.disable()` → use `vim.diagnostic.enable(false, opts)`
- [ ] Remove `vim.diagnostic.is_disabled()` → use `not vim.diagnostic.is_enabled(opts)`
- [ ] Update `vim.diagnostic.enable(bufnr, ns)` to `vim.diagnostic.enable(true, { bufnr = ..., ns_id = ... })`
- [ ] Replace `sign_define()` diagnostic signs with `vim.diagnostic.config({ signs = { text = {...} } })`
- [ ] Replace `vim.lsp.semantic_tokens.start()/stop()` with `.enable(true/false)`
- [ ] Test that `CTRL-R` in insert mode still works for your use case

### Step 2: Update deprecations (recommended)

- [ ] Replace `vim.lsp.buf_get_clients()` with `vim.lsp.get_clients({ buffer = bufnr })`
- [ ] Replace `vim.lsp.stop_client()` with `client:stop()`
- [ ] Replace `vim.lsp.set_log_level()` with `vim.lsp.log.set_level()`
- [ ] Replace `vim.lsp.get_log_path()` with `vim.lsp.log.get_filename()`
- [ ] Replace `vim.lsp.buf.range_code_action()` with `vim.lsp.buf.code_action({ range = ... })`
- [ ] Replace diagnostic `jump = { float = true }` with `jump = { on_jump = function() ... end }`
- [ ] Replace `vim.lsp.codelens.refresh()/clear()` with `.enable(true/false)`
- [ ] Replace `LanguageTree:for_each_child()` with `:children()`

### Step 3: Adopt native LSP config (optional but recommended)

- [ ] Create `~/.config/nvim/lsp/` directory
- [ ] Move LSP server configs from lspconfig setup calls into individual `lsp/<server>.lua` files
- [ ] Replace `require('lspconfig').<server>.setup({})` with `vim.lsp.enable({ '<server>' })`
- [ ] Move `on_attach` logic into a global `LspAttach` autocmd
- [ ] Set global LSP defaults with `vim.lsp.config('*', { ... })`

### Step 4: Adopt new features (optional)

- [ ] Try native autocomplete: `vim.opt.autocomplete = 'menu,menuone,noselect'`
- [ ] Set `vim.opt.winborder = 'rounded'` for global float borders
- [ ] Set `vim.opt.pumborder = true` for popup menu borders
- [ ] Try `:Undotree` to see if you can drop your undotree plugin
- [ ] Explore `vim.net.request()` for HTTP needs
- [ ] Add new highlight groups to your colorscheme if applicable

### Step 5: Test your plugins

- [ ] Update all plugins (`lazy sync` / `:lua vim.pack.update()`)
- [ ] Check noice.nvim — may need update for `ui-messages` changes
- [ ] Check mini.nvim — needs update for `get_parser()` nil handling
- [ ] Check any plugin using `vim.diff` or diagnostic APIs
- [ ] Run `:checkhealth` to verify everything is working

---

## Sources

- [Neovim news.txt (master)](https://github.com/neovim/neovim/blob/master/runtime/doc/news.txt)
- [Neovim deprecated.txt (master)](https://github.com/neovim/neovim/blob/master/runtime/doc/deprecated.txt)
- [Neovim 0.12 milestone](https://github.com/neovim/neovim/milestone/43)
- [nvim-lspconfig migration issue #3494](https://github.com/neovim/nvim-lspconfig/issues/3494)
- [Switching from lspconfig to vim.lsp.config](https://xnacly.me/posts/2025/neovim-lsp-changes/)
- [Neovim's built-in plugin manager](https://bower.sh/nvim-builtin-plugin-mgr)
