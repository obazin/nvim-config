local has = vim.fn.has
vim.fn.has = function(name)
  return name == 'nvim-0.12' and 0 or has(name)
end
local ok, err = pcall(dofile, 'init.lua')
T.eq(false, ok)
assert(err:find('requires Neovim 0.12', 1, true))
local errors = {}
for _, method in ipairs { 'start', 'info', 'ok', 'warn' } do
  vim.health[method] = function() end
end
vim.health.error = function(message)
  table.insert(errors, message)
end
require('plugins.health').check()
T.eq(1, #errors)
assert(errors[1]:find('requires 0.12', 1, true))
vim.fn.has = has
errors = {}
require('plugins.health').check()
T.eq({}, errors)
