-- Run filesystem scans in an isolated Neovim process. This keeps directory
-- traversal, frontmatter reads, and sorting off the editor's main thread.
local M = {}
local active = {}
local worker = assert(vim.api.nvim_get_runtime_file('lua/custom/file-scan-worker.lua', false)[1])

vim.api.nvim_create_autocmd('VimLeavePre', {
  group = vim.api.nvim_create_augroup('custom-file-scans', { clear = true }),
  callback = function()
    for cancel in pairs(active) do
      cancel()
    end
  end,
})

-- callback(result, error) runs on the main loop. Cancellation suppresses it.
function M.scan(kind, root, callback)
  local process, cancelled
  local function cancel()
    cancelled = true
    if process then
      pcall(process.kill, process, 15)
    end
  end
  local function finish(result, err)
    active[cancel] = nil
    process = nil
    if not cancelled then
      callback(result, err)
    end
  end
  active[cancel] = true
  local ok, result = pcall(
    vim.system,
    {
      vim.v.progpath,
      '--headless',
      '-u',
      'NONE',
      '-i',
      'NONE',
      '-n',
      '-l',
      worker,
      kind,
      root,
    },
    {},
    vim.schedule_wrap(function(output)
      if output.code ~= 0 then
        finish(nil, vim.trim(output.stderr or '') ~= '' and vim.trim(output.stderr) or 'File scan failed')
        return
      end
      local decoded, data = pcall(vim.json.decode, output.stdout)
      if decoded then
        finish(data)
      else
        finish(nil, 'Invalid file scan response: ' .. tostring(data))
      end
    end)
  )
  if ok then
    process = result
  else
    vim.schedule(function()
      finish(nil, tostring(result))
    end)
  end
  return cancel
end

return M
