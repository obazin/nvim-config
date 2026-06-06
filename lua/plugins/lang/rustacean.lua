return {
  'mrcjkb/rustaceanvim',
  version = '^9',
  lazy = false,
  config = function()
    local lib_ext = vim.uv.os_uname().sysname == 'Darwin' and 'dylib' or 'so'

    -- Resolve codelldb dynamically rather than hardcoding a nix store path:
    --   1. $PATH (e.g. a standalone `codelldb` from a `nix develop` shell)
    --   2. the vadimcn.vscode-lldb extension installed in the nix profile
    local vscode_lldb = vim.fn.expand '~/.nix-profile/share/vscode/extensions/vadimcn.vscode-lldb'
    local codelldb_path = vim.fn.exepath 'codelldb'
    if codelldb_path == '' then
      codelldb_path = vscode_lldb .. '/adapter/codelldb'
    end

    if vim.fn.executable(codelldb_path) == 1 then
      -- liblldb lives in a different relative spot depending on the source:
      --   - $PATH binary:        <prefix>/bin/codelldb  -> <prefix>/lib/liblldb.<ext>
      --   - vscode-lldb adapter: <ext>/adapter/codelldb -> <ext>/lldb/lib/liblldb.<ext>
      local bin_dir = vim.fn.fnamemodify(codelldb_path, ':h')
      local candidates = {
        vim.fn.resolve(bin_dir .. '/../lib/liblldb.' .. lib_ext),
        vscode_lldb .. '/lldb/lib/liblldb.' .. lib_ext,
      }
      local liblldb_path = candidates[1]
      for _, candidate in ipairs(candidates) do
        if vim.fn.filereadable(candidate) == 1 then
          liblldb_path = candidate
          break
        end
      end

      local cfg = require 'rustaceanvim.config'
      vim.g.rustaceanvim = {
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end
  end,
}
