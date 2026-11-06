--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Dashboard already handles an empty startup and excludes stdin. Extend it
-- only for a single directory argument; resolve relative paths before chdir.
if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
  local directory = vim.fn.fnamemodify(vim.fn.argv(0), ':p')
  vim.api.nvim_create_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup('startup-directory', { clear = true }),
    once = true,
    callback = function()
      vim.schedule(function()
        if vim.fn.isdirectory(vim.api.nvim_buf_get_name(0)) == 1 and not vim.bo.modified then
          vim.api.nvim_set_current_dir(directory)
          vim.cmd 'Dashboard'
        end
      end)
    end,
  })
end
