for _, name in ipairs { 'telescope.nvim', 'plenary.nvim' } do
  T.plugin(name)
end
require('telescope').setup {}
local root = vim.fn.tempname()
vim.fn.mkdir(root, 'p')
vim.fn.writefile({}, root .. '/.notes')
for name, tags in pairs { first = 'lua', second = 'work', both = 'lua, work' } do
  vim.fn.writefile({ '---', 'tags: [' .. tags .. ']', '---', name }, root .. '/' .. name .. '.md')
end
vim.api.nvim_set_current_dir(root)
vim.cmd.edit(root .. '/first.md')
local state = require 'telescope.actions.state'
local actions = require 'telescope.actions'
local function wait_picker(previous)
  assert(
    vim.wait(5000, function()
      if vim.bo.filetype ~= 'TelescopePrompt' or vim.api.nvim_get_current_buf() == previous then
        return false
      end
      local picker = state.get_current_picker(vim.api.nvim_get_current_buf())
      return picker.manager and picker:get_selection() ~= nil
    end),
    'Picker did not open'
  )
  return vim.api.nvim_get_current_buf()
end
require('custom.telescope-notes-tags').pick()
local prompt = wait_picker()
local chosen = state.get_selected_entry().value
assert(chosen == 'lua' or chosen == 'work')
actions.toggle_selection(prompt)
actions.move_selection_next(prompt)
assert(state.get_selected_entry().value ~= chosen)
actions.toggle_selection(prompt)
actions.select_default(prompt)
prompt = wait_picker(prompt)
local picker = state.get_current_picker(prompt)
T.eq(1, picker.manager:num_results())
T.eq(root .. '/both.md', state.get_selected_entry().path)
actions.select_default(prompt)
T.eq(root .. '/both.md', vim.api.nvim_buf_get_name(0))
vim.uv.fs_utime(root .. '/both.md', 2000000000, 2000000000)
require('custom.telescope-files-mtime').pick()
prompt = wait_picker()
T.eq(root .. '/both.md', state.get_selected_entry().path)
actions.close(prompt)
require('custom.telescope-files-mtime').pick()
vim.cmd.enew()
T.eq(
  false,
  vim.wait(200, function()
    return vim.bo.filetype == 'TelescopePrompt'
  end)
)
vim.fn.delete(root, 'rf')
