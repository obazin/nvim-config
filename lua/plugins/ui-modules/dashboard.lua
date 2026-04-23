return {
  'nvimdev/dashboard-nvim',
  -- event = 'VimEnter',
  -- lazy = false,
  priority = 1001,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  config = function()
    -- If nvim was opened with a directory arg, we're already in a project
    local opened_in_dir = false
    if vim.fn.argc() > 0 then
      local arg = vim.fn.argv(0)
      if vim.fn.isdirectory(arg) == 1 then
        opened_in_dir = true
      end
    end

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
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Find File',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f',
          },
          {
            desc = ' Grep',
            group = 'DiagnosticHint',
            action = 'Telescope live_grep',
            key = 'g',
          },
        },
        mru = {
          enable = true,
          limit = 12,
          icon = ' ',
          label = opened_in_dir and 'Recent Files in Workspace' or 'Recent Files',
          cwd_only = opened_in_dir,
        },
        project = {
          enable = not opened_in_dir,
          limit = 9,
          icon = ' ',
          label = ' Projects ',
          action = 'Telescope find_files cwd=',
        },
      },
    }
  end,
}
