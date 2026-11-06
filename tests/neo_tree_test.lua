local sort = require('plugins.navigation.neo-tree').opts.sort_function
local expected = { 'src', '.env', 'config.toml', 'main.lua', 'lib.rs', 'README.md', 'notes.md' }
for _, root in ipairs { '/tmp/project', '/tmp/.config/project', '/tmp/with.dots/project' } do
  local files = {}
  for _, name in ipairs { 'README.md', 'lib.rs', '.env', 'notes.md', 'main.lua', 'config.toml', 'src' } do
    table.insert(files, { path = root .. '/' .. name, type = name == 'src' and 'directory' or 'file' })
  end
  table.sort(files, sort)
  T.eq(
    expected,
    vim.tbl_map(function(file)
      return vim.fs.basename(file.path)
    end, files)
  )
end
