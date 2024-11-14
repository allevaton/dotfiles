local M = {}

M.setup = function()
  -- Mason setup
  require('mason').setup {
    ui = {
      icons = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗',
      },
    },
  }

  require('mason-lspconfig').setup {
    ensure_installed = {
      'tsserver',
      'pyright',
      'lua_ls',
      'rust_analyzer',
    },
    automatic_installation = true,
  }

  -- Configure formatters and linters
  require('mason-null-ls').setup {
    ensure_installed = {
      'prettier', -- For JavaScript/TypeScript/CSS/JSON/etc.
      'black',    -- For Python
      'stylua',   -- For Lua
    },
    automatic_installation = true,
    handlers = {},
  }

  local null_ls = require 'null-ls'
  local formatting = null_ls.builtins.formatting

  -- Default formatting options
  local default_prettier_config = {
    singleQuote = true,    -- Use single quotes
    semi = true,           -- Add semicolons
    tabWidth = 2,          -- 2 spaces for indentation
    printWidth = 100,      -- Line length
    trailingComma = 'es5', -- ES5 trailing commas
    arrowParens = 'avoid', -- Avoid parentheses in arrow functions when possible
  }

  local default_stylua_config = {
    column_width = 100,               -- Line length
    indent_type = 'Spaces',           -- Use spaces
    indent_width = 2,                 -- 2 spaces for indentation
    quote_style = 'AutoPreferSingle', -- Prefer single quotes
  }

  -- Helper function to merge configs with local ones if they exist
  local function merge_with_local_config(default_config, local_config_files, formatter_name)
    -- List of possible local config file locations
    local configs_found = {}
    local cwd = vim.fn.getcwd()

    for _, config_name in ipairs(local_config_files) do
      local config_path = cwd .. '/' .. config_name
      if vim.fn.filereadable(config_path) == 1 then
        table.insert(configs_found, config_path)
      end
    end

    -- If no local configs found, use defaults
    if #configs_found == 0 then
      return default_config
    end

    -- Log which config file is being used
    vim.notify(
      'Using local ' .. formatter_name .. ' config: ' .. configs_found[1],
      vim.log.levels.INFO
    )
    return nil -- Return nil to let the formatter use the local config
  end

  null_ls.setup {
    sources = {
      formatting.prettier.with {
        filetypes = {
          'javascript',
          'typescript',
          'javascriptreact',
          'typescriptreact',
          'css',
          'scss',
          'html',
          'json',
          'yaml',
          'markdown',
          'graphql',
        },
        -- Merge with local config or use defaults
        extra_args = function()
          return merge_with_local_config({
            '--config',
            vim.json.encode(default_prettier_config),
          }, {
            '.prettierrc',
            '.prettierrc.js',
            '.prettierrc.json',
            'prettier.config.js',
          }, 'Prettier')
        end,
      },
      formatting.black.with {
        filetypes = { 'python' },
        extra_args = function()
          return merge_with_local_config(
            { '--line-length', '100' },
            { 'pyproject.toml', 'setup.cfg', '.black' },
            'Black'
          )
        end,
      },
      formatting.stylua.with {
        filetypes = { 'lua' },
        extra_args = function()
          return merge_with_local_config({
            '--config-path',
            vim.fn.stdpath 'config' .. '/stylua.toml',
          }, { 'stylua.toml', '.stylua.toml' }, 'StyLua')
        end,
      },
    },
    -- Format on save
    on_attach = function(client, bufnr)
      if client.supports_method 'textDocument/formatting' then
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format {
              bufnr = bufnr,
              timeout_ms = 5000,
            }
          end,
        })
      end
    end,
  }

  -- LSP setup
  local lspconfig = require 'lspconfig'
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- Default LSP on_attach function
  local on_attach = function(client, bufnr)
    -- Disable formatting from LSP if we want to use null-ls instead
    if client.name == 'tsserver' then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    -- Enhanced hover support
    vim.keymap.set('n', 'gh', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { buffer = bufnr, desc = 'Show hover information' })

    -- Type definition (especially useful for TypeScript)
    vim.keymap.set(
      'n',
      'gt',
      vim.lsp.buf.type_definition,
      { buffer = bufnr, desc = 'Go to type definition' }
    )

    -- Signature help (show function parameters)
    vim.keymap.set(
      'i',
      '<C-k>',
      vim.lsp.buf.signature_help,
      { buffer = bufnr, desc = 'Show signature help' }
    )
  end

  -- Configure LSP servers
  require('mason-lspconfig').setup_handlers {
    function(server_name)
      local opts = {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- Server-specific settings
      if server_name == 'lua_ls' then
        opts.settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
          },
        }
      end

      if server_name == 'tsserver' then
        opts.root_dir = function(fname)
          local util = require 'lspconfig.util'
          return util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git')(fname)
              or util.path.dirname(fname)
        end
      end

      if server_name == 'pyright' then
        opts.settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'workspace',
            },
          },
        }
      end

      lspconfig[server_name].setup(opts)
    end,
  }
end

return M
