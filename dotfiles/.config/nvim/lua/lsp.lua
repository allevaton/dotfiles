local M = {}

M.setup = function()
  local lspconfig = require('lspconfig')
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- Configure your language servers here
  lspconfig.ts_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    root_dir = function(fname)
      local util = require('lspconfig.util')
      return util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git')(fname) or util.path.dirname(fname)
    end,
  }

  -- Add more language servers as needed, for example:
  lspconfig.pyright.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace"
        }
      }
    },
    root_dir = function(fname)
      local util = require('lspconfig.util')
      return util.root_pattern(
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        '.git'
      )(fname) or util.path.dirname(fname)
    end,
  }
end

return M
