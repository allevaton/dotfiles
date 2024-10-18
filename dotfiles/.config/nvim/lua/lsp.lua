local M = {}

M.setup = function()
  local lspconfig = require('lspconfig')

  -- Configure your language servers here
  lspconfig.ts_ls.setup {
    -- You can add more configuration options here
  }

  -- Add more language servers as needed, for example:
  -- lspconfig.pyright.setup {
  --   on_attach = on_attach,
  -- }
end

return M
