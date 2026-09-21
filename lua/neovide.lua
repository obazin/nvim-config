-- Neovide-specific configuration
-- This file has NO effect when nvim is launched in a terminal
if not vim.g.neovide then
  return
end

-- Font & frame are set in ~/.config/neovide/config.toml (applied before Neovim starts)

-- Line height (pixels between lines, 0 = natural)
vim.opt.linespace = 12

-- Restore statusline (dashboard-nvim sets laststatus=0).
-- cmdheight is deliberately not touched here: options.lua sets it to 0 and
-- forcing it back to 1 reserved an empty row under the statusline.
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'WinEnter' }, {
  callback = function()
    vim.opt.laststatus = 2
  end,
})

-- Longer timeout for key combinations (terminal uses 500ms)
vim.opt.timeoutlen = 800

-- Cursor: keep Neovide's animated ("jumping") cursor with its default
-- animation length (0.15s) and trail; not overridden on purpose.

-- Padding (in pixels)
vim.g.neovide_padding_top = 48
vim.g.neovide_padding_bottom = 4
vim.g.neovide_padding_left = 64
vim.g.neovide_padding_right = 64

-- Cmd+= / Cmd+- to zoom, Cmd+0 to reset.
-- Scale the whole UI rather than rewriting 'guifont': the font (family,
-- weights, size) is owned by ~/.config/neovide/config.toml so it stays in
-- sync with the terminal, and a guifont string cannot express the ExtraLight
-- weight — touching it would silently swap the text back to Regular.
local function zoom(factor)
  local current = vim.g.neovide_scale_factor or 1.0
  vim.g.neovide_scale_factor = math.max(0.5, math.min(3.0, current * factor))
end

vim.keymap.set('n', '<D-=>', function() zoom(1.1) end,
  { noremap = true, silent = true, desc = 'Zoom in' })
vim.keymap.set('n', '<D-->', function() zoom(1 / 1.1) end,
  { noremap = true, silent = true, desc = 'Zoom out' })
vim.keymap.set('n', '<D-0>', function()
  vim.g.neovide_scale_factor = 1.0
end, { noremap = true, silent = true, desc = 'Zoom reset' })
