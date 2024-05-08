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

-- Auto-open Neo-Tree when entering a directory buffer
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Open Neo-Tree on startup if directory',
  group = vim.api.nvim_create_augroup('neotree_start', { clear = true }),
  callback = function()
    local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
    if stats and stats.type == 'directory' then
      require('neo-tree.setup.netrw').hijack()
    end
  end,
})
