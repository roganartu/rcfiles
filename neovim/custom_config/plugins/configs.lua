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

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev
    "css-lsp",
    "html-lsp",
    "eslint-lsp",
    "typescript-language-server",
    "json-lsp",

    -- rust stuff
    "rust-analyzer",

    -- python things
    "pyright",
    "pylint",
    "jedi-language-server",
    "black",
    "isort",

    -- misc
    "yaml-language-server",
    "yamllint",
    "yamlfmt",
    "prettier",
    "curlylint",
    "taplo",
    "gitlint",
    "buf",
    "sql-formatter",
    "sqlls",

    -- Salt stuff
    "salt-lsp",

    -- Terraform stuff
    "terraform-ls",
    "tflint",

    -- Jenkinsfile stuff
    "groovy-language-server",

    -- go stuff
    "gopls",
    "goimports",

    -- docker stuff
    "dockerfile-language-server",
    "hadolint",

    -- ansible stuff
    "ansible-language-server",

    -- shell
    "shfmt",
    "shellcheck",
    "bash-language-server",
  },
}

return M
