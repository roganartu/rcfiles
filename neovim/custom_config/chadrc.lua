-- Just an example, supposed to be placed in /lua/custom/

local M = {}
local pluginConfs = require "custom.plugins.configs"
local userPlugins = require "custom.plugins"

-- make sure you maintain the structure of `core/default_config.lua` here,

M.plugins = {

  options = {
    lspconfig = {
      setup_lspconf = "custom.plugins.lspconfig",
    },

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

M.mappings = {
  misc = function()
    require("custom.mappings")
  end,

  ["neovim/nvim-lspconfig"] = function()
    local map = require("core.utils").map
    map("n", "<leader>q", ":Bdelete<CR>", { noremap = true, silent = true})
  end,
}

return M
