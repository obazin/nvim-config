-- Standalone worker, invoked by custom.file-scan with -u NONE (no user config).
local source = debug.getinfo(1, 'S').source:sub(2)
local lua_root = vim.fs.dirname(vim.fs.dirname(source))
package.path = lua_root .. '/?.lua;' .. package.path

local function scan(kind, root)
  assert(kind == 'notes' or kind == 'mtime', 'Unknown scan kind')
  local cmd = { 'rg', '--files', '--null', '--hidden' }
  for _, glob in ipairs { '!.git/', '!.venv/', '!.env/', '!env/', '!*cache/', '!node_modules/', '!target/', '!.direnv/' } do
    vim.list_extend(cmd, { '--glob', glob })
  end
  if kind == 'notes' then
    vim.list_extend(cmd, { '-t', 'md' })
  end
  vim.list_extend(cmd, { '--', root })
  local result = vim.system(cmd):wait()
  -- rg uses 1 for an empty result; failures must not silently bypass ignores.
  assert(result.code == 0 or result.code == 1, result.stderr)
  local paths = vim.split(result.stdout or '', '\0', { plain = true, trimempty = true })
  if kind == 'mtime' then
    local entries = {}
    for _, path in ipairs(paths) do
      local stat = vim.uv.fs_stat(path)
      if stat and stat.type == 'file' then
        table.insert(entries, { path = path, mtime = stat.mtime.sec, nsec = stat.mtime.nsec })
      end
    end
    table.sort(entries, function(a, b)
      if a.mtime ~= b.mtime then
        return a.mtime > b.mtime
      end
      if a.nsec ~= b.nsec then
        return a.nsec > b.nsec
      end
      return a.path < b.path
    end)
    return { entries = entries }
  end
  local counts, file_tags, errors = {}, {}, {}
  local tags = require 'custom.note-tags'
  for _, path in ipairs(paths) do
    local found, err = tags.read(path)
    if err then
      table.insert(errors, { path = path, message = err })
    elseif #found > 0 then
      file_tags[path] = found
      for _, tag in ipairs(found) do
        counts[tag] = (counts[tag] or 0) + 1
      end
    end
  end
  return { tag_counts = counts, file_to_tags = file_tags, errors = errors }
end

local ok, result = pcall(scan, arg[1], arg[2])
if not ok then
  io.stderr:write(tostring(result) .. '\n')
  vim.cmd 'cquit 1'
else
  io.stdout:write(vim.json.encode(result))
end
