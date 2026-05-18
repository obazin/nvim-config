-- Telescope picker: files in cwd sorted by mtime (most recently modified first).
--
-- Uses `rg --files` so .gitignore is honored. Each entry shows the modification
-- timestamp followed by the path relative to cwd. Telescope's fuzzy sorter
-- takes over once you start typing; the mtime order is the initial state.

local M = {}

local IGNORE_GLOBS = {
  '!.git/',
  '!.venv/',
  '!.env/',
  '!env/',
  '!*cache/',
  '!node_modules/',
  '!target/',
}

local function list_files(root)
  local cmd = { 'rg', '--files', '--hidden', '--no-messages' }
  for _, g in ipairs(IGNORE_GLOBS) do
    table.insert(cmd, '--glob')
    table.insert(cmd, g)
  end
  table.insert(cmd, root)
  local files = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return {}
  end
  return files
end

local function collect_with_mtime(files)
  local out = {}
  for _, path in ipairs(files) do
    local st = vim.uv.fs_stat(path)
    if st and st.type == 'file' then
      table.insert(out, { path = path, mtime = st.mtime.sec })
    end
  end
  table.sort(out, function(a, b)
    return a.mtime > b.mtime
  end)
  return out
end

function M.pick()
  local root = vim.fn.getcwd()
  local files = list_files(root)
  local entries = collect_with_mtime(files)
  if #entries == 0 then
    vim.notify('No files found in ' .. root, vim.log.levels.INFO)
    return
  end

  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local entry_display = require 'telescope.pickers.entry_display'
  local sorters = require 'telescope.sorters'

  local displayer = entry_display.create {
    separator = '  ',
    items = {
      { width = 16 },
      { remaining = true },
    },
  }

  pickers
    .new({}, {
      prompt_title = 'Files by modified date  (' .. root .. ')',
      finder = finders.new_table {
        results = entries,
        entry_maker = function(e)
          local rel = e.path
          if rel:sub(1, #root + 1) == root .. '/' then
            rel = rel:sub(#root + 2)
          end
          local stamp = os.date('%Y-%m-%d %H:%M', e.mtime)
          return {
            value = e.path,
            path = e.path,
            ordinal = rel,
            display = function()
              return displayer { { stamp, 'TelescopeResultsComment' }, rel }
            end,
          }
        end,
      },
      sorter = conf.file_sorter and conf.file_sorter {} or sorters.get_fuzzy_file(),
      previewer = conf.file_previewer {},
    })
    :find()
end

return M
