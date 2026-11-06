vim.opt.rtp:prepend(vim.env.AUDIT_CONFIG_ROOT)
vim.opt.rtp:append(vim.fn.stdpath 'data' .. '/lazy/dashboard-nvim')
vim.opt.rtp:append(vim.fn.stdpath 'data' .. '/lazy/nvim-web-devicons')
vim.g.loaded_netrwPlugin = 1
vim.o.loadplugins = false
require 'autocommands'
require('plugins.ui-modules.dashboard').config()
vim.cmd 'runtime plugin/dashboard.lua'
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    -- Headless Neovim has no UI; simulate its attachment for the plugin's normal
    -- empty-startup behavior, after its stdin detection has run.
    vim.api.nvim_exec_autocmds('UIEnter', {})
    vim.defer_fn(function()
      io.stdout:write(vim.json.encode {
        cwd = vim.fn.getcwd(),
        ft = vim.bo.filetype,
        lines = vim.api.nvim_buf_get_lines(0, 0, -1, false),
      })
      vim.cmd 'qa!'
    end, 100)
  end,
})
