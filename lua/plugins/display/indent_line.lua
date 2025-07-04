return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      exclude = {
        filetypes = { 'markdown', 'md', 'dashboard' },
      },
      debounce = 200,
      indent = {
        char = '▏',
      },
      scope = {
        show_start = false,
        show_end = false,
        exclude = { language = { 'markdown', 'md' } },
      },
    },
  },
}
