-- <C-h/j/k/l> across Neovim splits and the surrounding multiplexer.
--
-- Two multiplexers are in play: tmux (vim-tmux-navigator) and herdr. The herdr plugin
-- vim-herdr-navigation ships a Neovim shim that does the same edge hand-off for herdr
-- panes and falls back to :TmuxNavigate* under tmux, so when it is installed (by
-- nix-config, under ~/.config/herdr/nix-plugins) it owns the four mappings and
-- vim-tmux-navigator only provides the commands. Without it, vim-tmux-navigator maps
-- the keys itself as before.
local herdr_navigation = vim.fn.expand '~/.config/herdr/nix-plugins/vim-herdr-navigation/editor/nvim.lua'
local herdr_navigation_installed = (vim.uv or vim.loop).fs_stat(herdr_navigation) ~= nil

return {
  'christoomey/vim-tmux-navigator',
  init = function()
    if herdr_navigation_installed then
      vim.g.tmux_navigator_no_mappings = 1
    end
  end,
  config = function()
    if herdr_navigation_installed then
      dofile(herdr_navigation)
    end
  end,
}
