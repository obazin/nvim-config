local stdpath, system = vim.fn.stdpath, vim.fn.system
local root = vim.fn.tempname()
vim.fn.stdpath = function(kind)
  return kind == 'data' and root or stdpath(kind)
end
vim.fn.system = function(cmd)
  T.eq('git', cmd[1])
  system { 'sh', '-c', 'exit 1' }
  return 'simulated clone failure'
end
local ok, err = pcall(dofile, 'lua/lazy-init.lua')
T.eq(false, ok)
assert(err:find('Failed to install lazy.nvim', 1, true))
assert(err:find('simulated clone failure', 1, true))
assert(not vim.o.rtp:find(root, 1, true))
vim.fn.mkdir(root .. '/lazy/lazy.nvim', 'p')
vim.fn.system = function()
  error 'Existing installation must not be cloned'
end
dofile 'lua/lazy-init.lua'
assert(vim.o.rtp:find(root, 1, true))
vim.fn.stdpath, vim.fn.system = stdpath, system
vim.fn.delete(root, 'rf')
