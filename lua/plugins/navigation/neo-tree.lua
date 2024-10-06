-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>f', ':Neotree toggle float<CR>', silent = true, desc = 'Float File Explorer' },
    { '<leader>lf', ':Neotree toggle position=left<CR>', silent = true, desc = 'Left File Explorer' },
    { '<leader>ngs', ':Neotree float git_status<CR>', silent = true, desc = 'Neotree Open Git Status Window' },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          -- '.git',
          '.DS_Store',
          'thumbs.db',
        },
        never_show = {},
      },
      window = {
        position = 'float',
        mappings = {
          ['<leader>ee'] = 'close_window',
        },
      },
    },
  },
}
