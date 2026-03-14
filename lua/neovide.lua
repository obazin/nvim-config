-- Neovide-specific configuration
-- This file has NO effect when nvim is launched in a terminal
if not vim.g.neovide then
  return
end

-- Font & frame are set in ~/.config/neovide/config.toml (applied before Neovim starts)

-- Line height (pixels between lines, 0 = natural)
vim.opt.linespace = 12

-- Restore statusline (dashboard-nvim sets laststatus=0)
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'WinEnter' }, {
  callback = function()
    vim.opt.laststatus = 2
    vim.opt.cmdheight = 1
  end,
})

-- Longer timeout for key combinations (terminal uses 500ms)
vim.opt.timeoutlen = 800

-- Cursor animation
vim.g.neovide_cursor_animation_length = 0

-- Padding (in pixels)
vim.g.neovide_padding_top = 48
vim.g.neovide_padding_bottom = 4
vim.g.neovide_padding_left = 64
vim.g.neovide_padding_right = 64

-- Cmd+= / Cmd+- to resize font, Cmd+0 to reset
local function adjust_font_size(delta)
  local current = vim.o.guifont
  local size = tonumber(current:match(':h(%d+)')) or 12
  local new_size = math.max(8, math.min(32, size + delta))
  vim.o.guifont = current:gsub(':h%d+', ':h' .. new_size)
end

vim.keymap.set('n', '<D-=>', function() adjust_font_size(1) end,
  { noremap = true, silent = true, desc = 'Font size +' })
vim.keymap.set('n', '<D-->', function() adjust_font_size(-1) end,
  { noremap = true, silent = true, desc = 'Font size -' })
vim.keymap.set('n', '<D-0>', function()
  vim.o.guifont = 'JetBrainsMono Nerd Font:h12'
end, { noremap = true, silent = true, desc = 'Font size reset' })
