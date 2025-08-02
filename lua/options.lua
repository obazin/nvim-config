vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
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
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.cursorline = true
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.laststatus = 3 -- Global status on
vim.opt.hlsearch = true
vim.opt.inccommand = 'split'
vim.opt.showmode = false
