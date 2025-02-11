return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'windwp/nvim-ts-autotag',
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'css',
      'dockerfile',
      'html',
      'javascript',
      'json',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'python',
      'rust',
      'svelte',
      'typescript',
      'tsx',
      'vim',
      'vimdoc',
      'yaml',
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    autotag = { enable = true },
    textobjects = {
      select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
          ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
          ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
          ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },

          -- works for javascript/typescript files (custom capture I created in after/queries/ecma/textobjects.scm)
          ['a:'] = { query = '@property.outer', desc = 'Select outer part of an object property' },
          ['i:'] = { query = '@property.inner', desc = 'Select inner part of an object property' },
          ['l:'] = { query = '@property.lhs', desc = 'Select left part of an object property' },
          ['r:'] = { query = '@property.rhs', desc = 'Select right part of an object property' },

          ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
          ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },

          ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
          ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },

          ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
          ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },

          ['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
          ['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },

          ['am'] = { query = '@function.outer', desc = 'Select outer part of a method/function definition' },
          ['im'] = { query = '@function.inner', desc = 'Select inner part of a method/function definition' },

          ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
          ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>na'] = '@parameter.inner', -- swap parameters/argument with next
          ['<leader>n:'] = '@property.outer', -- swap object property with next
          ['<leader>nm'] = '@function.outer', -- swap function with next
        },
        swap_previous = {
          ['<leader>pa'] = '@parameter.inner', -- swap parameters/argument with prev
          ['<leader>p:'] = '@property.outer', -- swap object property with prev
          ['<leader>pm'] = '@function.outer', -- swap function with previous
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ['àf'] = { query = '@call.outer', desc = 'Next function call start' },
          ['àm'] = { query = '@function.outer', desc = 'Next method/function def start' },
          ['à'] = { query = '@class.outer', desc = 'Next class start' },
          ['ài'] = { query = '@conditional.outer', desc = 'Next conditional start' },
          ['àl'] = { query = '@loop.outer', desc = 'Next loop start' },

          -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
          -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
          ['às'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
          ['àz'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
        },
        goto_next_end = {
          ['àF'] = { query = '@call.outer', desc = 'Next function call end' },
          ['àM'] = { query = '@function.outer', desc = 'Next method/function def end' },
          ['àC'] = { query = '@class.outer', desc = 'Next class end' },
          ['àI'] = { query = '@conditional.outer', desc = 'Next conditional end' },
          ['àL'] = { query = '@loop.outer', desc = 'Next loop end' },
        },
        goto_previous_start = {
          ['çf'] = { query = '@call.outer', desc = 'Prev function call start' },
          ['çm'] = { query = '@function.outer', desc = 'Prev method/function def start' },
          ['çc'] = { query = '@class.outer', desc = 'Prev class start' },
          ['çi'] = { query = '@conditional.outer', desc = 'Prev conditional start' },
          ['çl'] = { query = '@loop.outer', desc = 'Prev loop start' },
        },
        goto_previous_end = {
          ['çF'] = { query = '@call.outer', desc = 'Prev function call end' },
          ['çM'] = { query = '@function.outer', desc = 'Prev method/function def end' },
          ['çC'] = { query = '@class.outer', desc = 'Prev class end' },
          ['çI'] = { query = '@conditional.outer', desc = 'Prev conditional end' },
          ['çL'] = { query = '@loop.outer', desc = 'Prev loop end' },
        },
      },
    },
  },
  config = function(_, opts)
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

    -- Prefer git instead of curl in order to improve connectivity in some environments
    require('nvim-treesitter.install').prefer_git = true
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup(opts)

    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  end,
}
