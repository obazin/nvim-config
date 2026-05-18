-- Telescope picker: search notes by frontmatter tags.
--
-- Detects a "notes folder" by walking up from cwd looking for a `.notes` or
-- `.obsidian` marker (file or directory). Scans markdown files there, parses
-- YAML frontmatter `tags:` (both `[a, b]` inline and `- a` block-list styles),
-- then shows a two-stage picker:
--   1. Tags with note counts. <Tab> multi-selects for AND filtering.
--   2. Notes carrying the chosen tag(s), with markdown preview.

local M = {}

local MARKERS = { '.notes', '.obsidian' }
local FRONTMATTER_READ_BYTES = 4096

local function find_notes_root()
  local start = vim.fn.expand '%:p:h'
  if start == '' then
    start = vim.fn.getcwd()
  end
  local hit = vim.fs.find(MARKERS, { upward = true, path = start, stop = vim.env.HOME, type = 'file' })[1]
    or vim.fs.find(MARKERS, { upward = true, path = start, stop = vim.env.HOME, type = 'directory' })[1]
  if hit then
    return vim.fs.dirname(hit)
  end
  return nil
end

local function strip_quotes(s)
  return (s:gsub('^["\']', ''):gsub('["\']$', ''))
end

local function parse_frontmatter_tags(filepath)
  local f = io.open(filepath, 'r')
  if not f then
    return nil
  end
  local head = f:read(FRONTMATTER_READ_BYTES)
  f:close()
  if not head or not head:match '^%-%-%-%s*\n' then
    return nil
  end
  local fm = head:match '^%-%-%-%s*\n(.-)\n%-%-%-'
  if not fm then
    return nil
  end

  local tags = {}

  -- Inline form: tags: [a, b, "c d"]
  local inline = fm:match 'tags:%s*%[(.-)%]'
  if inline then
    for tag in inline:gmatch '[^,]+' do
      local t = vim.trim(tag)
      if t ~= '' then
        table.insert(tags, strip_quotes(t))
      end
    end
    return tags
  end

  -- Block form:
  -- tags:
  --   - a
  --   - b
  local in_tags = false
  for line in (fm .. '\n'):gmatch '([^\n]*)\n' do
    if in_tags then
      local item = line:match '^%s+%-%s*(.+)%s*$'
      if item then
        table.insert(tags, strip_quotes(vim.trim(item)))
      elseif line:match '^%S' or line == '' then
        in_tags = false
      end
    end
    if line:match '^tags:%s*$' then
      in_tags = true
    end
  end
  return tags
end

local function scan_notes(root)
  local files = vim.fn.systemlist { 'rg', '--files', '-t', 'md', '--no-messages', root }
  if vim.v.shell_error ~= 0 then
    -- Fallback to find if rg is unavailable.
    files = vim.fn.systemlist { 'find', root, '-type', 'f', '-name', '*.md' }
  end
  local tag_counts = {}
  local file_to_tags = {}
  for _, file in ipairs(files) do
    local tags = parse_frontmatter_tags(file)
    if tags and #tags > 0 then
      file_to_tags[file] = tags
      for _, tag in ipairs(tags) do
        tag_counts[tag] = (tag_counts[tag] or 0) + 1
      end
    end
  end
  return tag_counts, file_to_tags
end

local function open_notes_picker(matching, selected_tags, root)
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values

  pickers
    .new({}, {
      prompt_title = 'Notes tagged: ' .. table.concat(selected_tags, ' & '),
      finder = finders.new_table {
        results = matching,
        entry_maker = function(path)
          local rel = vim.fn.fnamemodify(path, ':.')
          if root and path:sub(1, #root) == root then
            rel = path:sub(#root + 2)
          end
          return {
            value = path,
            display = rel,
            ordinal = rel,
            path = path,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      previewer = conf.file_previewer {},
    })
    :find()
end

function M.pick()
  local root = find_notes_root()
  if not root then
    vim.notify('No notes folder found (looked for ' .. table.concat(MARKERS, ' / ') .. ' upward)', vim.log.levels.WARN)
    return
  end

  local tag_counts, file_to_tags = scan_notes(root)
  if next(tag_counts) == nil then
    vim.notify('No tagged notes under ' .. root, vim.log.levels.INFO)
    return
  end

  local tag_list = {}
  for tag, count in pairs(tag_counts) do
    table.insert(tag_list, { tag = tag, count = count })
  end
  table.sort(tag_list, function(a, b)
    if a.count == b.count then
      return a.tag < b.tag
    end
    return a.count > b.count
  end)

  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  pickers
    .new({}, {
      prompt_title = 'Note tags  (' .. root .. ')  — <Tab> multi-select for AND',
      finder = finders.new_table {
        results = tag_list,
        entry_maker = function(entry)
          return {
            value = entry.tag,
            display = string.format('#%-32s %d', entry.tag, entry.count),
            ordinal = entry.tag,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          local picker = action_state.get_current_picker(prompt_bufnr)
          local multi = picker:get_multi_selection()
          local selected = {}
          if #multi > 0 then
            for _, s in ipairs(multi) do
              table.insert(selected, s.value)
            end
          else
            local entry = action_state.get_selected_entry()
            if not entry then
              return
            end
            table.insert(selected, entry.value)
          end
          actions.close(prompt_bufnr)

          local matching = {}
          for file, tags in pairs(file_to_tags) do
            local has_all = true
            for _, want in ipairs(selected) do
              local found = false
              for _, t in ipairs(tags) do
                if t == want then
                  found = true
                  break
                end
              end
              if not found then
                has_all = false
                break
              end
            end
            if has_all then
              table.insert(matching, file)
            end
          end
          table.sort(matching)

          if #matching == 0 then
            vim.notify('No notes match all selected tags', vim.log.levels.INFO)
            return
          end
          open_notes_picker(matching, selected, root)
        end)
        return true
      end,
    })
    :find()
end

return M
