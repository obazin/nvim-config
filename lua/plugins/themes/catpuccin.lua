return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  opts = {
    color_overrides = {
      macchiato = {
        peach = '#e17f74',
        yellow = '#d8bc99',
        green = '#caa7aa',
        teal = '#7fbab2',
      },
      -- Match Ghostty's background, between Catppuccin's mantle and base.
      mocha = { base = '#1a1a28' },
    },
  },
}
