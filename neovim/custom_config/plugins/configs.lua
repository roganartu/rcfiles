local M = {}

M.treesitter = {
   ensure_installed = {
      "bash",
      "c",
      "cpp",
      "css",
      "go",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "python",
      "rust",
      "toml",
   },
}

M.nvimtree = {
   git = {
      enable = true,
   },
}

return M
