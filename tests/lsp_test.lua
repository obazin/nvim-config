T.plugin 'nvim-lspconfig'
package.loaded['blink.cmp'] = {
  get_lsp_capabilities = function()
    return {}
  end,
}
package.loaded['telescope.builtin'] = setmetatable({}, {
  __index = function()
    return function() end
  end,
})
-- Exercise config and callbacks without starting external language servers.
vim.lsp.enable = function() end
require('plugins.lang.lspconfig').config()
local b1 = vim.api.nvim_create_buf(true, false)
local b2 = vim.api.nvim_create_buf(true, false)
vim.api.nvim_buf_set_name(b1, '/tmp/audit-ruff-first.py')
vim.api.nvim_buf_set_name(b2, '/tmp/audit-ruff-second.py')
local calls = {}
local client = {
  exec_cmd = function(_, command, ctx)
    table.insert(calls, { command, ctx })
  end,
}
vim.lsp.config.ruff.on_attach(client, b1)
T.eq(nil, vim.api.nvim_buf_get_commands(b2, {}).RuffAutofix)
assert(vim.api.nvim_buf_get_commands(b1, {}).RuffAutofix)
vim.api.nvim_buf_call(b1, function()
  vim.cmd.RuffAutofix()
  vim.cmd.RuffOrganizeImports()
end)
T.eq('ruff.applyAutofix', calls[1][1].command)
T.eq('ruff.applyOrganizeImports', calls[2][1].command)
for _, call in ipairs(calls) do
  T.eq({ { uri = vim.uri_from_bufnr(b1) } }, call[1].arguments)
  T.eq(b1, call[2].bufnr)
end
T.eq(nil, vim.lsp.config.ruff.commands)

-- Svelte's upstream on_attach owns JS/TS synchronization. Our shared callback
-- must not add another global watcher for each attached Svelte buffer.
T.eq('function', type(vim.lsp.config.svelte.on_attach))
vim.lsp.get_client_by_id = function()
  return {
    name = 'svelte',
    supports_method = function()
      return false
    end,
  }
end
local writes_before = #vim.api.nvim_get_autocmds { event = 'BufWritePost' }
for _, buf in ipairs { b1, b2 } do
  vim.api.nvim_exec_autocmds('LspAttach', { buffer = buf, data = { client_id = 1 } })
end
T.eq(writes_before, #vim.api.nvim_get_autocmds { event = 'BufWritePost' })
