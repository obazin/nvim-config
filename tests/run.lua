vim.opt.rtp:prepend(vim.fn.getcwd())
_G.T = {}
function T.eq(expected, actual)
  assert(vim.deep_equal(expected, actual), 'Expected ' .. vim.inspect(expected) .. ', got ' .. vim.inspect(actual))
end
function T.plugin(name)
  local path = vim.fn.stdpath 'data' .. '/lazy/' .. name
  assert(vim.uv.fs_stat(path), 'Install the locked plugins first: missing ' .. name)
  vim.opt.rtp:append(path)
end
local ok, err = xpcall(function()
  dofile(assert(arg[1], 'Pass a test file'))
end, debug.traceback)
if not ok then
  io.stderr:write(err .. '\n')
  vim.cmd 'cquit 1'
end
print('PASS ' .. arg[1])
