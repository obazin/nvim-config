return {
  'mrcjkb/rustaceanvim',
  version = '^9',
  lazy = false,
  config = function()
    -- Resolve codelldb from $PATH (provided per-project by `nix develop`).
    -- If it isn't available, let rustaceanvim fall back to its own auto-detection
    -- rather than forcing a broken adapter path.
    local codelldb_path = vim.fn.exepath 'codelldb'

    if codelldb_path ~= '' then
      -- liblldb usually sits alongside the nix-provided codelldb binary.
      local lib_ext = vim.uv.os_uname().sysname == 'Darwin' and 'dylib' or 'so'
      local liblldb_path = vim.fn.resolve(vim.fn.fnamemodify(codelldb_path, ':h') .. '/../lib/liblldb.' .. lib_ext)

      local cfg = require 'rustaceanvim.config'
      vim.g.rustaceanvim = {
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end
  end,
}
