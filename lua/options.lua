vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = 'yes'

vim.opt.breakindent = true
vim.opt.formatoptions = 'tcqn'
vim.opt.wrap = true
vim.opt.textwidth = 120
vim.o.conceallevel = 2
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.fileencoding = 'utf-8'
vim.opt.writebackup = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.swapfile = false

vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
-- Without a Wayland/X display no clipboard provider is found and '+' silently
-- stays local. Two cases:
--  * a multiplexer server (herdr, tmux) started from SSH hands its panes a
--    stale env with no WAYLAND_DISPLAY, even when used at the desk: adopt the
--    session's socket if one exists, so wl-copy reaches the desktop clipboard.
--  * a real SSH login (SSH_TTY set): copy through OSC 52 so yanks reach the
--    client's (e.g. the Mac's) clipboard via the terminal. Paste reads the
--    unnamed register instead, to avoid blocking on the terminal's
--    clipboard-read prompt.
local runtime_dir = vim.env.XDG_RUNTIME_DIR
if not vim.env.SSH_TTY and not vim.env.WAYLAND_DISPLAY and runtime_dir then
  local socket = vim.fn.glob(runtime_dir .. '/wayland-[0-9]', false, true)[1]
  if socket then
    vim.env.WAYLAND_DISPLAY = vim.fn.fnamemodify(socket, ':t')
  end
end
if vim.env.SSH_TTY then
  local osc52 = require('vim.ui.clipboard.osc52')
  local function paste()
    return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
  end
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = { ['+'] = osc52.copy('+'), ['*'] = osc52.copy('*') },
    paste = { ['+'] = paste, ['*'] = paste },
  }
end
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.cursorline = true
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.laststatus = 2 -- One statusline per window; lualine (globalstatus = false) forces this value anyway
vim.opt.cmdheight = 0 -- No reserved command-line row under the statusline; noice draws the cmdline as a popup
vim.opt.hlsearch = true
vim.opt.inccommand = 'split'
vim.opt.showmode = false

vim.opt.winborder = 'rounded'
vim.opt.pumborder = 'rounded'

-- Use inline colored circle instead of background for LSP document colors
vim.lsp.document_color.enable(true, nil, { style = '● ' })
