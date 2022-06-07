-- MAPPINGS
local M = {}

M.custom = {

  n = {
    -- Fast saving
    ["<Leader>w"] = {":w <CR>", "Write"},

    -- Abandon a buffer without closing the window/split
    -- This doesn't work atm.
    ["<leader>q"] = {
       function()
          require("core.utils").close_buffer()
       end,
       "   close buffer",
    },

    -- Clear search highlighting
    ["<leader><CR>"] = {':let @/=""<CR>', "Clear search highlighting", opts = { noremap = true, silent = true}},
  },

  v = {
    -- Allow shifting lines in visual mode without deselecting
    ["<"] = {"<gv", "Shift left", opts = { noremap = true }},
    [">"] = {">gv", "Shift right", opts = { noremap = true }},

    -- Yank into a different buffer
    ["<leader>y"] = {'"+y', "Yank into a separate buffer", opts = { noremap = true }},
    ["<leader>Y"] = {'"+Y', "Yank into a separate buffer", opts =  { noremap = true }},
    ["<leader>p"] = {'"+p', "Paste from a separate buffer", opts = { noremap = true }},
    ["<leader>P"] = {'"+P', "Paste from a separate buffer", opts = { noremap = true }},
  },
}

-- Telescope things
M.telescope = {
  n = {
    ["<leader>cc"] = {":Telescope <CR>", "Open Telescope"},

    ["<leader>fg"] = {"<cmd> :Telescope live_grep <CR>", "Live grep"},
    ["<C-p>"] = {"<cmd> :Telescope find_files <CR>", "File finder"},
  }
}

return M
