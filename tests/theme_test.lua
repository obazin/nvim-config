for _, name in ipairs { 'catppuccin', 'lualine.nvim', 'nvim-web-devicons', 'telescope.nvim', 'plenary.nvim' } do
  T.plugin(name)
end
require('catppuccin').setup(require('plugins.themes.catpuccin').opts)
vim.o.background = 'dark'
require('plugins.ui-modules.lualine').config()
local lualine = require 'lualine'
local setup, refreshes = lualine.setup, 0
local changes = 0
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    changes = changes + 1
  end,
})
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'background',
  callback = function()
    changes = changes + 1
  end,
})
lualine.setup = function(...)
  refreshes = refreshes + 1
  return setup(...)
end
local themes = require 'custom.theme-switcher'
themes.restore()
T.eq('catppuccin-mocha', vim.g.colors_name)
assert(changes > 0)
T.eq(changes, refreshes)
local state = vim.fn.stdpath 'state' .. '/theme.txt'
vim.fn.mkdir(vim.fs.dirname(state), 'p')
vim.fn.writefile({ 'missing-audit-theme' }, state)
local notify, warnings = vim.notify, {}
vim.notify = function(message)
  table.insert(warnings, message)
end
themes.restore()
T.eq('catppuccin-mocha', vim.g.colors_name)
T.eq(1, #warnings)
vim.notify = notify
require('telescope').setup {}
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local function open()
  themes.pick()
  local prompt = vim.api.nvim_get_current_buf()
  assert(vim.wait(2000, function()
    return action_state.get_selected_entry() ~= nil
  end))
  return prompt
end
local previous = vim.g.colors_name
local prompt = open()
actions.move_selection_next(prompt)
actions.close(prompt)
T.eq(previous, vim.g.colors_name)
prompt = open()
local selected = action_state.get_selected_entry()[1]
actions.select_default(prompt)
T.eq(selected, vim.g.colors_name)
T.eq({ selected }, vim.fn.readfile(state))
lualine.setup = setup
