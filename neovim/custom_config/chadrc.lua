local M = {}
local pluginConfs = require "custom.plugins.configs"
local userPlugins = require "custom.plugins"

-- make sure you maintain the structure of `core/default_config.lua` here,

M.plugins = {

  lspconfig = {
    servers = {
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
  },

  options = {
    statusline = {
      separator_style = "round",
    },
  },

  override = {
    ["nvim-treesitter/nvim-treesitter"] = pluginConfs.treesitter,
    ["kyazdani42/nvim-tree.lua"] = pluginConfs.nvimtree,
  },

  ui = {
    theme = "onedark",
  },

  user = userPlugins,
}

M.mappings = require("custom.mappings")

return M
