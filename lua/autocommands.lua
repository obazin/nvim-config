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

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname == '' or vim.fn.isdirectory(bufname) == 1 then
      vim.schedule(function()
        vim.cmd 'Dashboard'
      end)
    end
  end,
})
