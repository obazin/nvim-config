return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  dependencies = {
    { 'windwp/nvim-ts-autotag', opts = {} },
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
  },
  config = function()
    if not vim.fn.executable('tree-sitter') then
      vim.notify('tree-sitter-cli not found. Install it (e.g. `brew install tree-sitter-cli`) for parser compilation.', vim.log.levels.WARN)
    end

    -- Install parsers
    require('nvim-treesitter').install {
      'bash',
      'c',
      'css',
      'diff',
      'dockerfile',
      'html',
      'git_rebase',
      'javascript',
      'json',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'python',
      'regex',
      'rust',
      'svelte',
      'typescript',
      'tsx',
      'vim',
      'vimdoc',
      'yaml',
    }

    -- Enable treesitter highlighting and indentation for all filetypes
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- Configure textobjects
    require('nvim-treesitter-textobjects').setup {
      select = { lookahead = true },
      move = { set_jumps = true },
    }

    -- Helper to create select textobject keymap
    local function sel(lhs, query, desc, query_group)
      vim.keymap.set({ 'x', 'o' }, lhs, function()
        require('nvim-treesitter-textobjects.select').select_textobject(query, query_group or 'textobjects')
      end, { desc = desc })
    end

    -- Select keymaps
    sel('a=', '@assignment.outer', 'Select outer part of an assignment')
    sel('i=', '@assignment.inner', 'Select inner part of an assignment')
    sel('l=', '@assignment.lhs', 'Select left hand side of an assignment')
    sel('r=', '@assignment.rhs', 'Select right hand side of an assignment')
    sel('a:', '@property.outer', 'Select outer part of an object property')
    sel('i:', '@property.inner', 'Select inner part of an object property')
    sel('l:', '@property.lhs', 'Select left part of an object property')
    sel('r:', '@property.rhs', 'Select right part of an object property')
    sel('aa', '@parameter.outer', 'Select outer part of a parameter/argument')
    sel('ia', '@parameter.inner', 'Select inner part of a parameter/argument')
    sel('ai', '@conditional.outer', 'Select outer part of a conditional')
    sel('ii', '@conditional.inner', 'Select inner part of a conditional')
    sel('al', '@loop.outer', 'Select outer part of a loop')
    sel('il', '@loop.inner', 'Select inner part of a loop')
    sel('af', '@call.outer', 'Select outer part of a function call')
    sel('if', '@call.inner', 'Select inner part of a function call')
    sel('am', '@function.outer', 'Select outer part of a method/function definition')
    sel('im', '@function.inner', 'Select inner part of a method/function definition')
    sel('ac', '@class.outer', 'Select outer part of a class')
    sel('ic', '@class.inner', 'Select inner part of a class')

    -- Swap keymaps
    local swap = require('nvim-treesitter-textobjects.swap')
    vim.keymap.set('n', '<leader>sa', function() swap.swap_next('@parameter.inner') end, { desc = 'Swap next parameter' })
    vim.keymap.set('n', '<leader>s:', function() swap.swap_next('@property.outer') end, { desc = 'Swap next property' })
    vim.keymap.set('n', '<leader>sm', function() swap.swap_next('@function.outer') end, { desc = 'Swap next function' })
    vim.keymap.set('n', '<leader>sA', function() swap.swap_previous('@parameter.inner') end, { desc = 'Swap prev parameter' })
    vim.keymap.set('n', '<leader>s;', function() swap.swap_previous('@property.outer') end, { desc = 'Swap prev property' })
    vim.keymap.set('n', '<leader>sM', function() swap.swap_previous('@function.outer') end, { desc = 'Swap prev function' })

    -- Move keymaps
    local move = require('nvim-treesitter-textobjects.move')
    local move_modes = { 'n', 'x', 'o' }

    -- goto_next_start
    vim.keymap.set(move_modes, ']f', function() move.goto_next_start('@call.outer', 'textobjects') end, { desc = 'Next function call start' })
    vim.keymap.set(move_modes, ']m', function() move.goto_next_start('@function.outer', 'textobjects') end, { desc = 'Next method/function def start' })
    vim.keymap.set(move_modes, ']c', function() move.goto_next_start('@class.outer', 'textobjects') end, { desc = 'Next class start' })
    vim.keymap.set(move_modes, ']i', function() move.goto_next_start('@conditional.outer', 'textobjects') end, { desc = 'Next conditional start' })
    vim.keymap.set(move_modes, ']l', function() move.goto_next_start('@loop.outer', 'textobjects') end, { desc = 'Next loop start' })
    vim.keymap.set(move_modes, ']s', function() move.goto_next_start('@local.scope', 'locals') end, { desc = 'Next scope' })
    vim.keymap.set(move_modes, ']z', function() move.goto_next_start('@fold', 'folds') end, { desc = 'Next fold' })

    -- goto_next_end
    vim.keymap.set(move_modes, ']F', function() move.goto_next_end('@call.outer', 'textobjects') end, { desc = 'Next function call end' })
    vim.keymap.set(move_modes, ']M', function() move.goto_next_end('@function.outer', 'textobjects') end, { desc = 'Next method/function def end' })
    vim.keymap.set(move_modes, ']C', function() move.goto_next_end('@class.outer', 'textobjects') end, { desc = 'Next class end' })
    vim.keymap.set(move_modes, ']I', function() move.goto_next_end('@conditional.outer', 'textobjects') end, { desc = 'Next conditional end' })
    vim.keymap.set(move_modes, ']L', function() move.goto_next_end('@loop.outer', 'textobjects') end, { desc = 'Next loop end' })

    -- goto_previous_start
    vim.keymap.set(move_modes, '[f', function() move.goto_previous_start('@call.outer', 'textobjects') end, { desc = 'Prev function call start' })
    vim.keymap.set(move_modes, '[m', function() move.goto_previous_start('@function.outer', 'textobjects') end, { desc = 'Prev method/function def start' })
    vim.keymap.set(move_modes, '[c', function() move.goto_previous_start('@class.outer', 'textobjects') end, { desc = 'Prev class start' })
    vim.keymap.set(move_modes, '[i', function() move.goto_previous_start('@conditional.outer', 'textobjects') end, { desc = 'Prev conditional start' })
    vim.keymap.set(move_modes, '[l', function() move.goto_previous_start('@loop.outer', 'textobjects') end, { desc = 'Prev loop start' })

    -- goto_previous_end
    vim.keymap.set(move_modes, '[F', function() move.goto_previous_end('@call.outer', 'textobjects') end, { desc = 'Prev function call end' })
    vim.keymap.set(move_modes, '[M', function() move.goto_previous_end('@function.outer', 'textobjects') end, { desc = 'Prev method/function def end' })
    vim.keymap.set(move_modes, '[C', function() move.goto_previous_end('@class.outer', 'textobjects') end, { desc = 'Prev class end' })
    vim.keymap.set(move_modes, '[I', function() move.goto_previous_end('@conditional.outer', 'textobjects') end, { desc = 'Prev conditional end' })
    vim.keymap.set(move_modes, '[L', function() move.goto_previous_end('@loop.outer', 'textobjects') end, { desc = 'Prev loop end' })
  end,
}
