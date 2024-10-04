return {
  'luckasRanarison/tailwind-tools.nvim',
  name = 'tailwind-tools',
  build = ':UpdateRemotePlugins',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim', -- optional
    'neovim/nvim-lspconfig', -- optional
  },
  opts = {}, -- your configuration
}
-- TailwindConcealEnable: enables conceal for all buffers.
-- TailwindConcealDisable: disables conceal.
-- TailwindConcealToggle: toggles conceal.
-- TailwindColorEnable: enables color hints for all buffers.
-- TailwindColorDisable: disables color hints.
-- TailwindColorToggle: toggles color hints.
-- TailwindSort(Sync): sorts all classes in the current buffer.
-- TailwindSortSelection(Sync): sorts selected classes in visual mode.
-- TailwindNextClass: moves the cursor to the nearest next class node.
-- TailwindPrevClass: moves the cursor to the nearest previous class node.
