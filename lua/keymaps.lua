local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Move selected line / block of text in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", opts)
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Windows splitting
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split buffer vertically' })
vim.keymap.set('n', '<leader>wh', '<C-w>s', { desc = 'Split buffer horizontally' })

-- use jk to exit insert mode
vim.keymap.set('i', 'jk', '<ESC>:w<CR>', opts)
vim.keymap.set('i', 'jj', '<ESC>:w<CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x')
-- paste over currently selected text without yanking it
vim.keymap.set('v', 'p', '"_dp')
vim.keymap.set('v', 'P', '"_dP')

-- paste on new line
vim.keymap.set('n', '<C-p>', ':put<CR>')

-- buffer navigation
vim.keymap.set('n', '<Right>', ':bnext<CR>', opts)
vim.keymap.set('n', '<Left>', ':bprevious<CR>', opts)

-- Map enter to ciw in normal mode
vim.keymap.set('n', '<CR>', 'ciw', opts)
vim.keymap.set('n', '<BS>', 'ci', opts)
