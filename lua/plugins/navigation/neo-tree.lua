-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>lf', ':Neotree toggle position=left<CR>', silent = true, desc = 'Left File Explorer' },
    { '<leader>ngs', ':Neotree float git_status<CR>', silent = true, desc = 'Neotree Open Git Status Window' },
  },
  opts = {
    popup_border_style = 'rounded',
    open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
    sort_function = function(a, b)
      -- Always keep directories before files
      local is_dir_a = (a.type == 'directory')
      local is_dir_b = (b.type == 'directory')
      if is_dir_a ~= is_dir_b then
        return is_dir_a -- Directories first
      end

      -- Function to determine the sorting priority of a file
      local function get_priority(file)
        local path = file.name or vim.fs.basename(file.path)

        if path:match '^%.' then
          return 1
        end -- Dotfiles (highest priority)
        if path:match 'README%.md$' then
          return 4
        end -- README.md (last group but first in markdown)
        if
          path:match '%.sh$'
          or path:match '%.zsh$'
          or path:match '%.json$'
          or path:match '%.toml$'
          or path:match '%.yml$'
        then
          return 2
        end -- Config/Shell scripts
        if path:match '%.md$' then
          return 5
        end -- Markdown files (last group)

        return 3 -- Regular files (sorted by extension)
      end

      -- Compare based on priority
      local priority_a = get_priority(a)
      local priority_b = get_priority(b)
      if priority_a ~= priority_b then
        return priority_a < priority_b
      end

      -- If priority is the same, apply further sorting rules:
      if priority_a == 3 then
        -- Group regular files by extension
        local ext_a = (a.name or vim.fs.basename(a.path)):match '^.+%.(.+)$' or ''
        local ext_b = (b.name or vim.fs.basename(b.path)):match '^.+%.(.+)$' or ''
        if ext_a ~= ext_b then
          return ext_a < ext_b
        end
      end

      -- Final fallback: alphabetical order
      return a.path < b.path
    end,
    default_component_configs = {
      icon = { folder_empty = '󰜌' },
      modified = { symbol = '[+]' },
      git_status = {
        symbols = {
          added = '',
          modified = '',
          ignored = '󰜺',
          unstaged = '',
          staged = '',
          conflict = '',
        },
      },
      type = { required_width = 122 },
      created = { enabled = true, required_width = 110 },
    },
    window = { mappings = { i = 'show_file_details' } },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {},
        never_show = { '.DS_Store', 'thumbs.db' },
      },
      follow_current_file = { enabled = true },
      window = { mappings = { ['<c-x>'] = 'clear_filter' } },
      commands = {},
    },
    buffers = { show_unloaded = true },
    git_status = { window = { position = 'float' } },
  },
}
