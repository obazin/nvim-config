-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.o.laststatus = 3

require 'options'
require 'keymaps'
require 'autocommands'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-init'
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup {
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  -- Below are plugins to install first in order to  do not break anything
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  require 'plugins.navigation.vim_tmux',
  require 'plugins.display.git',
  require 'plugins.ui-modules.noice',
  require 'plugins.ui-modules.which-key',
  require 'plugins.ui-modules.telescope',
  require 'plugins.display.dimming',
  require 'plugins.ui-modules.zen',
  -- require 'plugins.display.transparent',
  require 'plugins.ui-modules.aerial',
  require 'plugins.display.folding',
  -- Lang support
  require 'plugins.lang.lspconfig',
  require 'plugins.lang.formatting',
  require 'plugins.lang.completion',
  -- Theme
  -- require 'plugins.themes.tokyonight',
  require 'plugins.themes.catpuccin',
  -- TODO comments management
  require 'plugins.display.todo-comments',
  require 'plugins.ui-modules.mini',
  -- Tressitter support
  require 'plugins.lang.treesitter',
  -- require 'plugins.lang.debug',
  -- require 'plugins.lang.markdown',
  require 'plugins.ui-modules.obsidian',
  require 'plugins.display.indent_line',
  require 'plugins.ui-modules.trouble',
  -- require 'plugins.lang.lint',
  require 'plugins.editing.autopairs',
  require 'plugins.editing.comment',
  require 'plugins.navigation.neo-tree',
  require 'plugins.ai.chatgpt',
  require 'plugins.ai.copilot-chat',
  require 'plugins.editing.neoclip',
  -- require 'plugins.display.gitsigns', -- adds gitsigns recommend keymaps
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
