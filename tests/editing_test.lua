vim.g.mapleader = ' '
require 'keymaps'
local path = vim.fn.tempname()
vim.fn.writefile({ 'original' }, path)
vim.cmd.edit(path)
for _, escape in ipairs { 'jj', 'jk' } do
  vim.api.nvim_feedkeys('A changed' .. escape, 'xt', false)
  T.eq({ 'original' }, vim.fn.readfile(path))
  T.eq(true, vim.bo.modified)
end
vim.api.nvim_feedkeys(' ww', 'xt', false)
T.eq(false, vim.bo.modified)
T.eq(vim.api.nvim_buf_get_lines(0, 0, -1, false), vim.fn.readfile(path))
vim.fn.delete(path)

-- Native commenting covers the configured line/selection workflow.
vim.bo.commentstring = '-- %s'
vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'local value = 1', 'return value' })
vim.api.nvim_win_set_cursor(0, { 1, 0 })
vim.api.nvim_feedkeys('gcc', 'xt', false)
T.eq('-- local value = 1', vim.api.nvim_buf_get_lines(0, 0, 1, false)[1])
vim.api.nvim_feedkeys('gcc', 'xt', false)
T.eq('local value = 1', vim.api.nvim_buf_get_lines(0, 0, 1, false)[1])
vim.api.nvim_feedkeys('Vjgc', 'xt', false)
T.eq({ '-- local value = 1', '-- return value' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
