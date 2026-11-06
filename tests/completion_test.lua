for _, name in ipairs { 'blink.cmp', 'friendly-snippets', 'lazydev.nvim' } do
  T.plugin(name)
end
require('lazydev').setup {}
local opts = vim.deepcopy(require('plugins.lang.completion').opts)
opts.fuzzy.implementation = 'lua' -- No binary downloads during verification.
require('blink.cmp').setup(opts)
local config = require 'blink.cmp.config'
T.eq('default', config.snippets.preset)
assert(vim.tbl_contains(config.sources.default, 'buffer'))
local source = require('blink.cmp.sources.snippets').new {}
assert(#source.registry:get_snippets_for_ft 'lua' > 0, 'Friendly Lua snippets must be discoverable')
config.snippets.expand 'hello ${1:world}!$0'
T.eq({ 'hello world!' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
assert(vim.snippet.active { direction = 1 })
vim.snippet.jump(1)
vim.snippet.stop()
