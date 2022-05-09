return {
  ["xiyaowong/nvim-transparent"] = {
    enable = true,
  },

  ["neovim/nvim-lspconfig"] = {
    setup = function()
      require("core.mappings").lspconfig()

      local map = require("core.utils").map

      -- These work
      map("n", "<leader>a", function()
       require("core.utils").close_buffer()
      end)
      map("n", "<leader>d", function()
       require("core.utils").close_buffer()
      end)

      -- These don't
      map("n", "<leader>q", function()
       require("core.utils").close_buffer()
      end)
      map("n", "<leader>D", function()
       require("core.utils").close_buffer()
      end)
    end,
  },
}
