-- Telescope picker: files in cwd sorted by mtime (most recently modified first).
--
-- Uses `rg --files` so .gitignore is honored. Each entry shows the modification
-- timestamp followed by the path relative to cwd. Telescope's fuzzy sorter
-- takes over once you start typing; the mtime order is the initial state.

local M = {}

local cancel_scan

local function open_picker(root, entries)
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local entry_display = require 'telescope.pickers.entry_display'

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
      sorter = conf.file_sorter {},
      previewer = conf.file_previewer {},
    })
    :find()
end
function M.pick()
  if cancel_scan then
    cancel_scan()
  end
  local root, buffer = vim.fn.getcwd(), vim.api.nvim_get_current_buf()
  cancel_scan = require('custom.file-scan').scan('mtime', root, function(result, err)
    if vim.fn.getcwd() ~= root or vim.api.nvim_get_current_buf() ~= buffer then
      return
    end
    if err then
      vim.notify(err, vim.log.levels.ERROR)
      return
    end
    if #result.entries == 0 then
      vim.notify('No files found in ' .. root, vim.log.levels.INFO)
      return
    end
    open_picker(root, result.entries)
  end)
end

return M
