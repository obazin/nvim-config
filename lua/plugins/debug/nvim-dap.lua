return {
  'mfussenegger/nvim-dap',
  config = function()
    local dap, dapui = require 'dap', require 'dapui'
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.keymap.set('n', '<Leader>dl', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<Leader>dj', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<Leader>dk', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<Leader>dc', dap.continue, { desc = 'Debug: Continue' })
    vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    -- vim.keymap.set('n', '<Leader>dd', dap.condi, { desc = 'Debug: Conditional Breakpoint' })
    vim.keymap.set('n', '<Leader>de', dap.terminate, { desc = 'Debug: Reset' })
    vim.keymap.set('n', '<Leader>dr', dap.run_last, { desc = 'Debug: Run Last' })
    vim.keymap.set('n', '<Leader>dt', "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = 'Debug: Testables' })
  end,
}
