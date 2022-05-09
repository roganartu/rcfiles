-- MAPPINGS
local map = require("core.utils").map

map("n", "<leader>cc", ":Telescope <CR>")

-- Fast saving
map("n", "<Leader>w", ":w <CR>")

-- Abandon a buffer without closing the window/split
map("n", "<leader>q", ":Bdelete<CR>", { noremap = true, silent = true})

-- Clear search highlighting
map("n", "<leader><CR>", ':let @/=""<CR>', { noremap = true, silent = true})

-- Telescope things
map("n", "<leader>fg", "<cmd> :Telescope live_grep <CR>")
map("n", "<C-p>", "<cmd> :Telescope find_files <CR>")

-- Allow shifting lines in visual mode without deselecting
map("v", "<", "<gv", { noremap = true })
map("v", ">", ">gv", { noremap = true })

-- Yank into a different buffer
map("v", "<leader>y", '"+y', { noremap = true })
map("v", "<leader>Y", '"+Y', { noremap = true })
map("v", "<leader>p", '"+p', { noremap = true })
map("v", "<leader>P", '"+P', { noremap = true })
map("n", "<leader>y", '"+y', { noremap = true })
map("n", "<leader>Y", '"+Y', { noremap = true })
map("n", "<leader>p", '"+p', { noremap = true })
map("n", "<leader>P", '"+P', { noremap = true })
