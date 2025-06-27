return {
  'nvimdev/dashboard-nvim',
  -- event = 'VimEnter',
  -- lazy = false,
  priority = 1001,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      packages = { enable = false },
      config = {
        week_header = {
          enable = false,
        },
        shortcut = {
          {
            desc = '󰊳 Update',
            group = '@property',
            action = 'Lazy update',
            key = 'u',
          },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Find File',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f',
          },
          {
            desc = ' Grep',
            group = 'DiagnosticHint',
            action = 'Telescope live_grep',
            key = 'g',
          },
        },
        -- Show only recent files in current working directory
        mru = {
          enable = true,
          limit = 12,
          icon = ' ',
          label = 'Recent Files in Workspace',
          cwd_only = true,
        },
        -- Optional: show projects if you use project.nvim
        -- project = {
        --   enable = true,
        --   limit = 8,
        --   icon = ' ',
        --   label = ' Projects ',
        --   action = 'Telescope find_files cwd=',
        -- },
        -- footer = {
        --   '',
        --   '📂 Recent files in this workspace only!',
        -- },
      },
    }
  end,
}
