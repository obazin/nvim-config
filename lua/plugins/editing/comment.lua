-- Use `opts = {}` to force a plugin to be loaded.
--  This is equivalent to:
--    require('Comment').setup({})
-- "gc" to comment visual regions/lines
return {
  'numToStr/Comment.nvim',
  opts = {},
  lazy = false,
}
