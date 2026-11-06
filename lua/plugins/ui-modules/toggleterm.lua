return {
  'akinsho/toggleterm.nvim',
  version = '*',
  -- Keep the spec (and its lockfile entry) in terminal sessions too.
  cond = function()
    return not not vim.g.neovide
  end,
  opts = {
    open_mapping = [[<c-\>]],
    direction = 'vertical',
    size = 80,
    shade_terminals = false,
  },
}
