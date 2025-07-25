return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    -- 'mason-org/mason.nvim',
    -- 'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    -- 'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- require('mason-nvim-dap').setup {
    --   -- Makes a best effort to setup the various debuggers with
    --   -- reasonable debug configurations
    --   automatic_setup = true,
    --
    --   -- You can provide additional configuration to the handlers,
    --   -- see mason-nvim-dap README for more information
    --   handlers = {},
    --
    --   -- You'll need to check that you have the required things installed
    --   -- online, please don't ask me how to install them :)
    --   ensure_installed = {
    --     -- Update this to ensure that you have the debuggers for the langs you want
    --     'delve',
    --   },
    -- }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<Leader>dl', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<Leader>dj', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<Leader>dk', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<Leader>dc', dap.continue, { desc = 'Debug: Continue' })
    vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<Leader>de', dap.terminate, { desc = 'Debug: Reset' })
    vim.keymap.set('n', '<Leader>dr', dap.run_last, { desc = 'Debug: Run Last' })
    vim.keymap.set('n', '<Leader>dt', "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = 'Debug: Testables' })
    vim.keymap.set('n', '<leader>dd', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })
    vim.keymap.set('n', '<Leader>dl', dapui.toggle, { desc = 'Debug: See last session result.' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    dap.listeners.before.attach['dapui_config'] = dapui.open
    dap.listeners.before.launch['dapui_config'] = dapui.open
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    -- require('dap-go').setup()
  end,
}
