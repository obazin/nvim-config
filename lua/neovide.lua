-- Neovide-specific configuration
-- This file has NO effect when nvim is launched in a terminal
if not vim.g.neovide then
  return
end

-- Font (JetBrains Mono Nerd Font, size 12)
vim.o.guifont = 'JetBrainsMono Nerd Font:h12'

-- Line height: pixels added between lines (vim linespace option, now supported by Neovide)
-- 0 = natural height, increase to add breathing room
vim.opt.linespace = 12

-- Window decorations (macOS): "transparent" | "buttonless" | "none" | "full"
-- "transparent" = no title bar frame, closest to Ghostty look
-- "none" = zero decorations but window can't be moved/resized
vim.g.neovide_frame = 'none'

-- Restore statusline (dashboard-nvim sets laststatus=0)
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'WinEnter' }, {
  callback = function()
    vim.opt.laststatus = 2
    vim.opt.cmdheight = 1
  end,
})

-- Cursor animation
vim.g.neovide_cursor_animation_length = 0

-- Padding (in pixels)
vim.g.neovide_padding_top = 48
vim.g.neovide_padding_bottom = 4
vim.g.neovide_padding_left = 64
vim.g.neovide_padding_right = 64
