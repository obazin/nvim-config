# Neovim 0.12 Migration TODO

Audit of `~/.config/nvim` — only tasks relevant to this specific config.

---

## Breaking / Removed (will cause errors)

- [ ] **Replace `vim.diagnostic.goto_prev`/`goto_next` (deprecated, removed in 0.12)**
  - File: `lua/keymaps.lua:14-15`
  - Replace with `vim.diagnostic.jump()`:
    ```lua
    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, { desc = 'Go to previous [D]iagnostic message' })
    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, { desc = 'Go to next [D]iagnostic message' })
    ```
  - Alternative: remove these entirely — 0.12 maps `[d`/`]d` by default

- [ ] **Move `on_attach` out of `vim.lsp.config()` calls (not a valid native key)**
  - File: `lua/plugins/lang/lspconfig.lua:242-252` (svelte)
  - File: `lua/plugins/lang/lspconfig.lua:317-321` (ruff)
  - `vim.lsp.config()` does not support `on_attach` — these callbacks are silently ignored
  - Move the logic into the existing `LspAttach` autocmd at line 17, filtered by `client.name`:
    ```lua
    -- Inside the existing LspAttach callback:
    if client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
    end
    if client.name == 'svelte' then
      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = { '*.js', '*.ts' },
        callback = function(ctx)
          client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.match })
        end,
      })
    end
    ```

---

## Deprecations (still work but should be updated now)

- [ ] **Replace `vim.loop` with `vim.uv`**
  - File: `lua/lazy-init.lua:3`
  - Change `vim.loop.fs_stat(lazypath)` to `vim.uv.fs_stat(lazypath)`

---

## Cleanup / Consistency

- [ ] **Resolve hybrid LSP setup (nvim-lspconfig + vim.lsp.config dual registration)**
  - File: `lua/plugins/lang/lspconfig.lua`
  - Servers like pyright, ruff, svelte, tailwindcss, html, emmet_ls are configured twice:
    once via `require('lspconfig')[server_name].setup()` (line 193) and again via `vim.lsp.config()` (lines 197-364)
  - Pick one approach:
    - **Option A (recommended)**: Go fully native — drop `nvim-lspconfig`, create `lsp/*.lua` files, use `vim.lsp.enable()`
    - **Option B**: Keep `nvim-lspconfig` — remove the `vim.lsp.config()` calls and put all config in the `servers` table

- [ ] **Remove stale `tsserver` hack**
  - File: `lua/plugins/lang/lspconfig.lua:184-187`
  - The `servers` table uses `vtsls`, not `tsserver` — this rename hack is no longer needed
    ```lua
    -- Remove this block:
    if server_name == 'tsserver' then
      server_name = 'ts_ls'
    end
    ```

---

## Plugin compatibility checks

- [ ] **Update noice.nvim before upgrading**
  - File: `lua/plugins/ui-modules/noice.lua`
  - 0.12 changes `ui-messages` events (`msg_show` gains new params, some events removed)
  - Ensure noice.nvim is at latest version before upgrading Neovim

- [ ] **Update all plugins via `lazy sync`**
  - mini.nvim, neo-tree, telescope, etc. may have 0.12 compatibility patches
  - Run `:checkhealth` after updating

---

## Optional improvements (new 0.12 features)

- [ ] **Set global floating window borders with `vim.opt.winborder`**
  - File: `lua/options.lua`
  - Add `vim.opt.winborder = 'rounded'` to get borders on all floats globally
  - Could simplify per-plugin border config (e.g. diagnostic float border at `lspconfig.lua:102`)

- [ ] **Set popup menu border with `vim.opt.pumborder`**
  - File: `lua/options.lua`
  - Add `vim.opt.pumborder = true`

- [ ] **Consider native LSP completion (`vim.lsp.completion`)**
  - Currently using blink.cmp — native completion is now viable for simpler setups
  - 0.12 adds `vim.opt.autocomplete` option for automatic triggering
  - Only worth it if you want to reduce plugin dependencies
