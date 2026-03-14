-- =============================================================================
-- Theme switcher — Telescope-based, with live preview and persistence
-- =============================================================================

local M = {}

local state_file = vim.fn.stdpath 'state' .. '/theme.txt'

-- ---------------------------------------------------------------------------
-- Persistence
-- ---------------------------------------------------------------------------

local function save(name)
  local f = io.open(state_file, 'w')
  if f then
    f:write(name)
    f:close()
  end
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
-- Apply theme + refresh lualine
-- ---------------------------------------------------------------------------

local function apply(name)
  local ok = pcall(vim.cmd.colorscheme, name)
  if not ok then return end
  pcall(function()
    require('lualine').setup(
      vim.tbl_deep_extend('force', require('lualine').get_config(), {
        options = { theme = 'auto' },
      })
    )
  end)
end

-- ---------------------------------------------------------------------------
-- Restore saved theme at startup
-- ---------------------------------------------------------------------------

function M.restore()
  local name = load() or 'catppuccin-mocha'
  apply(name)
end

-- ---------------------------------------------------------------------------
-- Telescope picker
-- ---------------------------------------------------------------------------

function M.pick()
  local pickers     = require 'telescope.pickers'
  local finders     = require 'telescope.finders'
  local conf        = require('telescope.config').values
  local actions     = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local themes   = vim.fn.getcompletion('', 'color')
  local previous = vim.g.colors_name
  local confirmed = false

  pickers.new({}, {
    prompt_title = 'Theme Switcher',
    finder = finders.new_table { results = themes },
    sorter = conf.generic_sorter {},

    attach_mappings = function(prompt_bufnr)
      -- Live preview: hook movement actions (results buffer, not prompt buffer)
      local preview = function()
        local entry = action_state.get_selected_entry()
        if entry then pcall(apply, entry[1]) end
      end

      actions.move_selection_next:enhance     { post = preview }
      actions.move_selection_previous:enhance { post = preview }
      actions.move_to_top:enhance             { post = preview }
      actions.move_to_bottom:enhance          { post = preview }
      actions.move_to_middle:enhance          { post = preview }

      -- Confirm: save and keep
      actions.select_default:replace(function()
        confirmed = true
        actions.close(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        if entry then
          apply(entry[1])
          save(entry[1])
        end
      end)

      -- Cancel: restore previous theme
      actions.close:enhance {
        post = function()
          if not confirmed and previous then
            apply(previous)
          end
        end,
      }

      return true
    end,
  }):find()
end

-- ---------------------------------------------------------------------------
-- Keymap
-- ---------------------------------------------------------------------------

vim.keymap.set('n', '<leader>st', M.pick, { desc = 'Theme switcher' })

return M
