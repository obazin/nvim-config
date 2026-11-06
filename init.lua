if vim.fn.has 'nvim-0.12' == 0 then
  error 'This configuration requires Neovim 0.12 or newer'
end

require 'options'
require 'neovide'
require 'keymaps'
require 'autocommands'

-- Bootstrap the plugin manager, then load the explicit plugin manifest.
require 'lazy-init'
require('lazy').setup {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  require 'plugins.navigation.vim_multiplexer',
  require 'plugins.ui-modules.dashboard',
  require 'plugins.display.git',
  require 'plugins.ui-modules.lazygit',
  require 'plugins.ui-modules.blame',
  require 'plugins.ui-modules.noice',
  require 'plugins.ui-modules.which-key',
  require 'plugins.ui-modules.telescope',
  require 'plugins.display.dimming',
  require 'plugins.ui-modules.zen',
  require 'plugins.ui-modules.yazi',
  require 'plugins.ui-modules.aerial',
  require 'plugins.display.folding',
  -- AI
  require 'plugins.ai.claudecode',
  -- Lang support
  require 'plugins.lang.lspconfig',
  require 'plugins.lang.formatting',
  require 'plugins.lang.completion',
  require 'plugins.lang.rustacean',
  -- Debug support
  require 'plugins.lang.debug',
  -- Theme
  require 'plugins.themes.tokyonight',
  require 'plugins.themes.catpuccin',
  require 'plugins.themes.nordic',
  require 'plugins.themes.nord',
  require 'plugins.themes.kanso',
  require 'plugins.themes.material',
  -- TODO comments management
  require 'plugins.display.todo-comments',
  require 'plugins.ui-modules.lualine',
  require 'plugins.ui-modules.mini',
  -- Tree-sitter support
  require 'plugins.lang.treesitter',
  require 'plugins.lang.markdown',
  require 'plugins.display.indent_line',
  require 'plugins.ui-modules.trouble',
  require 'plugins.editing.autopairs',
  require 'plugins.navigation.neo-tree',
  require 'plugins.editing.neoclip',
  require 'plugins.navigation.flash',
  require 'plugins.ui-modules.toggleterm',
}

-- Restore last saved theme and register keymap
require('custom.theme-switcher').restore()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
