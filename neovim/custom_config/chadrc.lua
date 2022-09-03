local M = {}
local pluginConfs = require "custom.plugins.configs"
local userPlugins = require "custom.plugins"

-- make sure you maintain the structure of `core/default_config.lua` here,

M.plugins = {

  options = {
    statusline = {
      separator_style = "round",
    },
  },

  override = {
    ["nvim-treesitter/nvim-treesitter"] = pluginConfs.treesitter,
    ["kyazdani42/nvim-tree.lua"] = pluginConfs.nvimtree,
    ["williamboman/mason.nvim"] = pluginConfs.mason,
  },

  ui = {
    theme = "onedark",
  },

  user = userPlugins,
}

M.mappings = require("custom.mappings")

return M
