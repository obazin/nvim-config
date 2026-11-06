-- =============================================================================
-- Theme switcher — Telescope-based, with live preview and persistence
-- =============================================================================

local M = {}

local state_file = vim.fn.stdpath 'state' .. '/theme.txt'

-- ---------------------------------------------------------------------------
-- Persistence
-- ---------------------------------------------------------------------------

local function save(name)
  vim.fn.mkdir(vim.fs.dirname(state_file), 'p')
  local f, err = io.open(state_file, 'w')
  if f then
    local ok
    ok, err = f:write(name)
    f:close()
    if ok then
      return
    end
  end
  vim.notify('Could not save theme: ' .. tostring(err), vim.log.levels.WARN)
end

local function load()
  local f = io.open(state_file, 'r')
  if f then
    local name = f:read '*l'
    f:close()
    return name
  end
end

-- ---------------------------------------------------------------------------
-- Apply theme; lualine refreshes itself on ColorScheme.
-- ---------------------------------------------------------------------------

local function apply(name)
  return pcall(vim.cmd.colorscheme, name)
end

-- ---------------------------------------------------------------------------
-- Restore saved theme at startup
-- ---------------------------------------------------------------------------

function M.restore()
  local name = load() or 'catppuccin-mocha'
  if not apply(name) then
    vim.notify('Saved theme is unavailable: ' .. name .. '. Using Catppuccin Mocha.', vim.log.levels.WARN)
    vim.cmd.colorscheme 'catppuccin-mocha'
  end
end

-- ---------------------------------------------------------------------------
-- Telescope picker
-- ---------------------------------------------------------------------------

function M.pick()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local themes = vim.fn.getcompletion('', 'color')
  local previous = vim.g.colors_name
  local previous_background = vim.o.background
  local confirmed = false

  pickers
    .new({}, {
      prompt_title = 'Theme Switcher',
      finder = finders.new_table { results = themes },
      sorter = conf.generic_sorter {},

      attach_mappings = function(prompt_bufnr)
        -- Live preview: hook movement actions (results buffer, not prompt buffer)
        local preview = function()
          local entry = action_state.get_selected_entry()
          if entry then
            pcall(apply, entry[1])
          end
        end

        actions.move_selection_next:enhance { post = preview }
        actions.move_selection_previous:enhance { post = preview }
        actions.move_to_top:enhance { post = preview }
        actions.move_to_bottom:enhance { post = preview }
        actions.move_to_middle:enhance { post = preview }

        -- Confirm: save and keep
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          confirmed = entry ~= nil and apply(entry[1])
          actions.close(prompt_bufnr)
          if confirmed then
            save(entry[1])
          end
        end)

        -- Cancel: restore previous theme
        actions.close:enhance {
          post = function()
            if not confirmed and previous then
              vim.o.background = previous_background
              apply(previous)
            end
          end,
        }

        return true
      end,
    })
    :find()
end

-- ---------------------------------------------------------------------------
-- Keymap
-- ---------------------------------------------------------------------------

vim.keymap.set('n', '<leader>ut', M.pick, { desc = '[U]I [T]heme switcher' })

return M
