local M = {}

M.setup_lsp = function(attach, capabilities)
  local lspconfig = require "lspconfig"

  local servers = {
    "ansiblels",
    "bashls",
    "ccls",
    "clangd",
    "cmake",
    "cssls",
    "dockerls",
    "emmet_ls",
    "gopls",
    "html",
    "jsonls",
    "pyright",
    "rust_analyzer",
    "salt_ls",
    "sqls",
    "tailwindcss",
    "tsserver" ,
    "yamlls" ,
  }

  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = attach,
      capabilities = capabilities,
    }
  end
end

return M
