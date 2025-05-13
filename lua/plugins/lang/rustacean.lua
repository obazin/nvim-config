return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false,
  config = function()
    -- Get Mason root
    local mason_path = vim.fn.expand '$MASON'
    local package_path = mason_path .. '/packages/codelldb/extension/'
    local codelldb_path = package_path .. 'adapter/codelldb'

    -- You'll need to adjust this for your OS if not macOS
    local liblldb_path = package_path .. 'lldb/lib/liblldb.dylib'

    local cfg = require 'rustaceanvim.config'

    vim.g.rustaceanvim = {
      dap = {
        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
      },
    }
  end,
}
