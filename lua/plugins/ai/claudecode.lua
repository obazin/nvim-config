return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = true,
  opts = {
    terminal_cmd = vim.env.CLAUDE_CODE_PATH or 'claude',
    terminal = {
      split_side            = 'right',
      split_width_percentage = 0.35,
      provider              = 'auto',
    },
    diff_opts = {
      layout = 'vertical',
    },
  },
  keys = {
    { '<leader>a',  nil,                              desc = 'Claude Code' },
    { '<leader>ac', '<cmd>ClaudeCode<cr>',            desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>',       desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>',   desc = 'Resume session' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue session' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select model' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>',       desc = 'Add current buffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>',        mode = 'v',               desc = 'Send selection' },
    {
      '<leader>as',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file from tree',
      ft = { 'neo-tree', 'NvimTree', 'oil', 'minifiles', 'netrw' },
    },
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>',   desc = 'Deny diff' },
  },
}
