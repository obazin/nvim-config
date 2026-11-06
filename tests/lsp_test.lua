T.plugin 'nvim-lspconfig'
vim.g.mapleader = ' '
local get_clients, get_client_by_id = vim.lsp.get_clients, vim.lsp.get_client_by_id
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

local clients = {}
for id = 1, 3 do
  clients[id] = {
    id = id,
    name = 'test',
    supports_method = function(_, method)
      return method == 'textDocument/documentHighlight'
    end,
  }
end
vim.lsp.get_client_by_id = function(id)
  return clients[id]
end
vim.lsp.get_clients = function()
  return { clients[1], clients[2] }
end
local function event(name, buf, id)
  vim.api.nvim_exec_autocmds(name, { buffer = buf, data = { client_id = id } })
end
local function highlight_count(buf)
  return #vim.api.nvim_get_autocmds { group = 'lsp-document-highlight', buffer = buf }
end
event('LspAttach', b1, 1)
event('LspAttach', b1, 2)
event('LspAttach', b2, 3)
T.eq(4, highlight_count(b1))
event('LspDetach', b1, 1)
T.eq(4, highlight_count(b1))
local cleared
vim.lsp.buf.clear_references = function()
  cleared = vim.api.nvim_get_current_buf()
end
vim.lsp.get_clients = function()
  return { clients[2] }
end
vim.api.nvim_set_current_buf(b2)
event('LspDetach', b1, 2)
T.eq(0, highlight_count(b1))
T.eq(4, highlight_count(b2))
T.eq(b1, cleared)
T.eq(b2, vim.api.nvim_get_current_buf())
clients[1].supports_method = function(_, method)
  return method == 'textDocument/inlayHint'
end
event('LspAttach', b1, 1)
local toggle = vim.api.nvim_buf_call(b1, function()
  return vim.fn.maparg(' th', 'n', false, true).callback
end)
vim.lsp.get_clients, vim.lsp.get_client_by_id = get_clients, get_client_by_id
vim.lsp.inlay_hint.enable(false)
toggle()
T.eq(true, vim.lsp.inlay_hint.is_enabled { bufnr = b1 })
T.eq(false, vim.lsp.inlay_hint.is_enabled { bufnr = b2 })
toggle()
T.eq(false, vim.lsp.inlay_hint.is_enabled { bufnr = b1 })
