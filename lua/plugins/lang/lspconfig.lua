return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'mason-org/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'saghen/blink.cmp',

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    -- { 'j-hui/fidget.nvim', opts = {} },

    -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    { 'folke/neodev.nvim', opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- Create local mapping function to avoid repetitions
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        --  To jump back, press <C-t>.
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

        -- Fuzzy find all the symbols in your current document.
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace.
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if
          client
          and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, { bufrn = event.buf })
        then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if
          client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, { bufrn = event.buf })
        then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    }

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Needed to detect root for monorepo exposing several not correlated projects with uv
    -- TODO:Remove these two stuffs or use them
    -- local util = require 'lspconfig.util'

    -- Auto-detect venv
    -- local function get_python_env(workspace)
    --   local venv_path = workspace .. '/.venv'
    --   if vim.fn.isdirectory(venv_path) == 1 then
    --     return venv_path
    --   end
    --   return nil -- No virtual environment found
    -- end

    local servers = {
      -- clangd = {},
      -- gopls = {},
      html = {},
      bashls = {},
      cssls = {},
      emmet_ls = {},
      dockerls = {},
      docker_compose_language_service = {},
      pyright = {},
      ruff = {},
      svelte = {},
      vtsls = {},
      tailwindcss = {},
      tinymist = {},
    }

    require('mason').setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
      'shfmt',
      'codelldb', -- DAP adapter for Rust and other languages
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          -- temp hack needed before Mason updates
          if server_name == 'tsserver' then
            server_name = 'ts_ls'
          end
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { 'vim', 'require' },
          },
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
    })

    vim.lsp.config('html', {
      filetypes = { 'html', 'twig', 'hbs' },
    })

    vim.lsp.config('css_ls', {
      settings = {
        css = {
          validate = true,
          lint = {
            unknownAtRules = 'ignore',
          },
        },
        scss = {
          validate = true,
          lint = {
            unknownAtRules = 'ignore',
          },
        },
        less = {
          validate = true,
          lint = {
            unknownAtRules = 'ignore',
          },
        },
      },
    })

    vim.lsp.config('emmet_ls', {
      filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'svelte' },
    })

    vim.lsp.config('pyright', {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = 'strict',

            diagnosticSeverityOverrides = {
              -- Fix diagnostics level
              reportUnknownParameterType = 'warning',
              reportMissingParameterType = 'warning',
              reportUnknownArgumentType = 'warning',
              reportUnknownLambdaType = 'warning',
              reportUnknownMemberType = 'warning',
              reportUnusedFunction = 'warning',
              reportUntypedFunctionDecorator = 'warning',
              reportDeprecated = 'warning',

              -- Enable extra diagnostics
              reportUnusedCallResult = 'warning',
              reportUninitializedInstanceVariable = 'warning',

              -- Gradual typing in new projects
              reportMissingImports = false,
              reportMissingTypeStubs = false,
              reportUnknownVariableType = false,

              -- Covered by ruff
              reportUnusedImport = false,
            },
          },
        },
      },
    })

    vim.lsp.config('ruff', {
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          callback = function()
            local uri = vim.uri_from_bufnr(bufnr)
            local clients = vim.lsp.get_clients { bufnr = bufnr }
            for _, lsp_client in ipairs(clients) do
              if lsp_client.name == 'ruff' then
                lsp_client:exec_cmd {
                  title = 'Organize Imports',
                  command = 'ruff.applyOrganizeImports',
                  arguments = {
                    {
                      uri = uri,
                      version = vim.lsp.util.buf_versions[bufnr] or 0,
                    },
                  },
                }
              end
            end
          end,
        })
      end,
      commands = {
        RuffAutofix = {
          function()
            local bufnr = vim.api.nvim_get_current_buf()
            local uri = vim.uri_from_bufnr(bufnr)
            for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
              if client.name == 'ruff' then
                client:exec_cmd {
                  title = 'Apply Auto Fix',
                  command = 'ruff.applyAutofix',
                  arguments = { { uri = uri } },
                }
              end
            end
          end,
          description = 'Ruff: Fix all auto-fixable problems',
        },
        RuffOrganizeImports = {
          function()
            local bufnr = vim.api.nvim_get_current_buf()
            local uri = vim.uri_from_bufnr(bufnr)
            for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
              if client.name == 'ruff' then
                client:exec_cmd {
                  title = 'Organize Imports',
                  command = 'ruff.applyOrganizeImports',
                  arguments = { { uri = uri } },
                }
              end
            end
          end,
          description = 'Ruff: Format imports',
        },
      },
    })

    vim.lsp.config('svelte', { -- configure svelte server
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd('BufWritePost', {
          pattern = { '*.js', '*.ts' },
          callback = function(ctx)
            -- Here use ctx.match instead of ctx.file
            client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.match })
          end,
        })
      end,
    })

    vim.lsp.config('tailwindcss', { -- exclude a filetype from the default_config
      filetypes_exclude = { 'markdown' },
      -- add additional filetypes to the default_config
      filetypes_include = {},
      -- to fully override the default_config, change the below
      filetypes = {
        'html',
        'css',
        'scss',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'svelte',
      },
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              'tw`([^`]*)`', -- tw`...`
              'tw\\(([^)]*)\\)', -- tw(...)
            },
          },
        },
      },
    })

    vim.lsp.config('tinymist', {
      settings = {
        formatterMode = 'typstyle',
        exportPdf = 'onType',
        semanticTokens = 'disable',
      },
    })
  end,
}
