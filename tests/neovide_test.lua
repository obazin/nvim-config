vim.g.neovide = true
require 'options'
require 'neovide'
T.eq(800, vim.o.timeoutlen)
vim.o.laststatus = 0
for _, event in ipairs { 'BufEnter', 'BufWinEnter', 'WinEnter' } do
  vim.api.nvim_exec_autocmds(event, {})
  T.eq(0, vim.o.laststatus)
end
local dashboard
package.loaded.dashboard = {
  setup = function(opts)
    dashboard = opts
  end,
}
require('plugins.ui-modules.dashboard').config()
T.eq(false, dashboard.hide.statusline)
vim.env.KITTY_LISTEN_ON, vim.env.WEZTERM_PANE = 'unix:/tmp/kitty', '1'
local zen = require('plugins.ui-modules.zen').opts
T.eq(false, zen.plugins.kitty.enabled)
T.eq(false, zen.plugins.wezterm.enabled)
vim.g.neovide = nil
require('plugins.ui-modules.dashboard').config()
T.eq(true, dashboard.hide.statusline)
