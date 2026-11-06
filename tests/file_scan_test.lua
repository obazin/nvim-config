local scanner = require 'custom.file-scan'
local root = vim.fn.tempname()
vim.fn.mkdir(root .. '/.git', 'p')
vim.fn.mkdir(root .. '/node_modules', 'p')
vim.fn.writefile({ 'ignored.md' }, root .. '/.gitignore')
local function note(name, lines)
  vim.fn.writefile(lines or { '---', 'tags: [work, work, lua]', '---' }, root .. '/' .. name)
end
note 'one.md'
note 'two\nlines.md' -- File enumeration must not split filenames at newlines.
note 'ignored.md'
note 'node_modules/vendor.md'
note('bad.md', { '---', 'tags: [unfinished', '---' })
local function scan(kind)
  local done, result, err, responsive
  vim.schedule(function()
    responsive = true
  end)
  scanner.scan(kind, root, function(data, error_message)
    assert(responsive, 'The editor main loop must remain available during scans')
    result, err, done = data, error_message, true
  end)
  assert(not done, 'Scans must complete asynchronously')
  assert(
    vim.wait(10000, function()
      return done
    end),
    'Scan timed out'
  )
  return result, err
end
local notes, err = scan 'notes'
T.eq(nil, err)
T.eq({ work = 2, lua = 2 }, notes.tag_counts)
T.eq(2, vim.tbl_count(notes.file_to_tags))
T.eq(1, #notes.errors)
T.eq(root .. '/bad.md', notes.errors[1].path)
vim.uv.fs_utime(root .. '/one.md', 2000000000, 2000000000)
local files = assert(scan 'mtime')
T.eq(root .. '/one.md', files.entries[1].path)
T.eq(4, #files.entries) -- three notes plus .gitignore; excluded files stay excluded.
local cancelled_callback = false
scanner.scan('mtime', root, function()
  cancelled_callback = true
end)()
vim.wait(100, function()
  return cancelled_callback
end)
T.eq(false, cancelled_callback)
local path = vim.env.PATH
vim.env.PATH = root -- Child Neovim still starts by absolute path; rg cannot.
local missing, missing_err = scan 'notes'
vim.env.PATH = path
T.eq(nil, missing)
assert(missing_err and missing_err:find('rg', 1, true))
vim.fn.delete(root, 'rf')

local empty = vim.fn.tempname()
vim.fn.mkdir(empty, 'p')
root = empty
local result = assert(scan 'notes')
T.eq({}, result.tag_counts)
vim.fn.delete(empty, 'rf')
