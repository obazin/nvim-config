return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Catppuccin Mocha palette
    local mode_colors = {
      n       = '#89b4fa', -- blue    — Normal
      i       = '#a6e3a1', -- green   — Insert
      v       = '#cba6f7', -- mauve   — Visual
      V       = '#cba6f7',
      ['\22'] = '#cba6f7', -- Ctrl-V
      c       = '#f9e2af', -- yellow  — Command
      R       = '#f38ba8', -- red     — Replace
      s       = '#fab387', -- peach   — Select
      S       = '#fab387',
      t       = '#94e2d5', -- teal    — Terminal
    }

    local function mode_circle()
      return '●'
    end

    local function mode_color()
      local m = vim.fn.mode()
      return { fg = mode_colors[m] or '#7aa2f7', bg = 'NONE' }
    end

    require('lualine').setup {
      options = {
        theme                = 'catppuccin-mocha',
        globalstatus         = false, -- one statusline per window
        component_separators = '',
        section_separators   = '',
      },
      sections = {
        lualine_a = { { mode_circle, color = mode_color, padding = { left = 2, right = 1 } } },
        lualine_b = { { 'filename', path = 0, symbols = { modified = ' ●', readonly = ' ', unnamed = '[No Name]' } } },
        lualine_c = {},
        lualine_x = { { 'filetype', icon_only = true, padding = { left = 1, right = 2 } } },
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = { { 'filename', path = 0, color = { fg = '#6c7086' } } },
        lualine_c = {},
        lualine_x = { { 'filetype', icon_only = true, color = { fg = '#6c7086' }, padding = { left = 1, right = 2 } } },
        lualine_y = {},
        lualine_z = {},
      },
    }
  end,
}
