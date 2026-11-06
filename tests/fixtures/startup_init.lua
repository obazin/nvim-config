local root = assert(vim.env.AUDIT_CONFIG_ROOT)
vim.opt.rtp:prepend(root)
vim.opt.rtp:prepend(vim.fn.stdpath 'data' .. '/lazy/lazy.nvim')
if vim.env.AUDIT_NEOVIDE == '1' then
  vim.g.neovide = true
end
local errors = {}
local notify = vim.notify
vim.notify = function(message, level, opts)
  if level == vim.log.levels.ERROR then
    table.insert(errors, message)
  end
  return notify(message, level, opts)
end
local setup = require('lazy').setup
require('lazy').setup = function(spec)
  return setup(spec, {
    install = { missing = false },
    checker = { enabled = false },
    change_detection = { enabled = false },
    lockfile = vim.env.AUDIT_LOCKFILE,
    performance = { rtp = { paths = { root } } },
  })
end
local treesitter = require 'plugins.lang.treesitter'
local configure = treesitter.config
treesitter.config = function()
  require('nvim-treesitter').install = function() end -- No downloads in tests.
  configure()
end
require('plugins.ai.claudecode').opts.auto_start = false -- No listening service in tests.
dofile(root .. '/init.lua')
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.defer_fn(function()
      local ok, err = xpcall(function()
        local plugins = {}
        for name, plugin in pairs(require('lazy.core.config').plugins) do
          plugins[name] = not not plugin._.loaded
        end
        require('lazy.manage.lock').update()
        io.stdout:write(vim.json.encode {
          plugins = plugins,
          errors = errors,
          errmsg = vim.v.errmsg,
          messages = vim.api.nvim_exec2('messages', { output = true }).output,
          timeoutlen = vim.o.timeoutlen,
          lazydev = vim.fn.exists ':LazyDev',
          loop = vim.fn.maparg('il', 'o', false, true).desc,
          swap = vim.fn.maparg(' sxm', 'n', false, true).desc,
          search = vim.fn.maparg(' sm', 'n', false, true).desc,
          snippets = require('blink.cmp.config').snippets.preset,
        })
      end, debug.traceback)
      if not ok then
        io.stderr:write(err)
        vim.cmd 'cquit 1'
      end
      vim.cmd 'qa!'
    end, 300)
  end,
})
