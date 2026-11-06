T.plugin 'conform.nvim'
local opts = require('plugins.lang.formatting').opts
require('conform').setup(opts)
vim.bo.filetype = vim.filetype.match { filename = '/tmp/script.sh', contents = { '#!/usr/bin/env bash', 'echo hello' } }
T.eq('sh', vim.bo.filetype)
T.eq('shfmt', require('conform').list_formatters(0)[1].name)
T.eq('fallback', opts.format_on_save(0).lsp_format)
for _, ft in ipairs { 'c', 'cpp' } do
  vim.bo.filetype = ft
  T.eq('never', opts.format_on_save(0).lsp_format)
end
