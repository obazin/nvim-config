return {
  'stevearc/aerial.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = 'AerialToggle',
  keys = {
    { '<leader>o', '<cmd>AerialToggle!<CR>', desc = 'Toggle document outline' },
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    on_attach = function(bufnr)
      vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr, desc = 'Previous document symbol' })
      vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr, desc = 'Next document symbol' })
    end,
  },
}
