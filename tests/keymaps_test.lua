vim.g.mapleader = ' '
for _, name in ipairs { 'mini.nvim', 'nvim-treesitter-textobjects', 'telescope.nvim', 'plenary.nvim' } do
  T.plugin(name)
end
package.loaded['nvim-treesitter'] = { install = function() end }
local function verify()
  for _, mode in ipairs { 'o', 'x' } do
    T.eq('Select outer part of a loop', vim.fn.maparg('al', mode, false, true).desc)
    T.eq('Select inner part of a loop', vim.fn.maparg('il', mode, false, true).desc)
  end
  T.eq('Swap next function', vim.fn.maparg(' sxm', 'n', false, true).desc)
  T.eq('[S]earch files by [M]odified date', vim.fn.maparg(' sm', 'n', false, true).desc)
  T.eq('', vim.fn.maparg('sa', 'n'))
  assert(vim.fn.maparg('gsa', 'n') ~= '')
end
require('plugins.lang.treesitter').config()
require('plugins.ui-modules.mini').config()
require('plugins.ui-modules.telescope').config()
verify()
-- Reversing setup order must not change ownership of the loop mappings.
require('plugins.ui-modules.mini').config()
require('plugins.lang.treesitter').config()
verify()

local executable, notify = vim.fn.executable, vim.notify
local warnings = {}
vim.fn.executable = function(name)
  return name == 'tree-sitter' and 0 or executable(name)
end
vim.notify = function(message, level)
  table.insert(warnings, { message, level })
end
require('plugins.lang.treesitter').config()
T.eq(1, #warnings)
T.eq(vim.log.levels.WARN, warnings[1][2])
vim.fn.executable, vim.notify = executable, notify
