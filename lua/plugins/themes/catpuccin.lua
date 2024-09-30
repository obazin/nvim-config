return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  opts = {
    color_overrides = {
      -- original-macchiato = {
      -- rosewater = "#f4dbd6",
      -- flamingo = "#f0c6c6",
      -- pink = "#f5bde6",
      -- mauve = "#c6a0f6",
      -- red = "#ed8796",
      -- maroon = "#ee99a0",
      -- peach = "#f5a97f",
      -- yellow = "#eed49f",
      -- green = "#a6da95",
      -- teal = "#8bd5ca",
      -- sky = "#91d7e3",
      -- sapphire = "#7dc4e4",
      -- blue = "#8aadf4",
      -- lavender = "#b7bdf8",
      -- text = "#cad3f5",
      -- subtext1 = "#b8c0e0",
      -- subtext0 = "#a5adcb",
      -- overlay2 = "#939ab7",
      -- overlay1 = "#8087a2",
      -- overlay0 = "#6e738d",
      -- surface2 = "#5b6078",
      -- surface1 = "#494d64",
      -- surface0 = "#363a4f",
      -- base = "#24273a",
      -- mantle = "#1e2030",
      -- crust = "#181926",
      -- },
      -- macchiato = {
      --   rosewater = '#f4dbd6',
      --   flamingo = '#f0c6c6',
      --   pink = '#f5bde6',
      --   mauve = '#c6a0f6',
      --   red = '#ed8796',
      --   maroon = '#ee99a0',
      --   peach = '#f6998f',
      --   yellow = '#eed4af',
      --   green = '#dec4bf',
      --   teal = '#8bd5ca',
      --   sky = '#91d7e3',
      --   sapphire = '#7dc4e4',
      --   blue = '#8aadf4',
      --   lavender = '#b7bdf8',
      --   text = '#cad3f5',
      --   subtext1 = '#b8c0e0',
      --   subtext0 = '#a5adcb',
      --   overlay2 = '#939ab7',
      --   overlay1 = '#8087a2',
      --   overlay0 = '#6e738d',
      --   surface2 = '#5b6078',
      --   surface1 = '#494d64',
      --   surface0 = '#363a4f',
      --   base = '#24273a',
      --   mantle = '#1e2030',
      --   crust = '#181926',
      -- },
      macchiato = {
        rosewater = '#ddc2bd', -- Darkened and desaturated
        flamingo = '#d9a9a9', -- Darkened and desaturated
        pink = '#d595c6', -- Darkened and desaturated
        mauve = '#997ad6', -- Further darkened
        red = '#ed8796', -- Unchanged
        maroon = '#ee99a0', -- Unchanged
        peach = '#e17f74', -- Further darkened and desaturated
        yellow = '#d8bc99', -- Further darkened and desaturated
        green = '#caa7aa', -- Further darkened and desaturated
        teal = '#7fbab2', -- Slightly adjusted
        sky = '#91d7e3', -- Unchanged
        sapphire = '#7dc4e4', -- Unchanged
        blue = '#8aadf4', -- Unchanged
        lavender = '#b7bdf8', -- Further darkened
        text = '#cad3f5', -- Unchanged
        subtext1 = '#b8c0e0', -- Unchanged
        subtext0 = '#a5adcb', -- Unchanged
        overlay2 = '#939ab7', -- Unchanged
        overlay1 = '#8087a2', -- Unchanged
        overlay0 = '#6e738d', -- Unchanged
        surface2 = '#5b6078', -- Unchanged
        surface1 = '#494d64', -- Unchanged
        surface0 = '#363a4f', -- Unchanged
        base = '#24273a', -- Unchanged
        mantle = '#1e2030', -- Unchanged
        crust = '#181926', -- Unchanged
      },
    },
  },
  init = function()
    vim.cmd.colorscheme 'catppuccin-macchiato'
  end,
}
