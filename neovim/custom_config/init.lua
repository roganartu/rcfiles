-- example file i.e lua/custom/init.lua

-- Relative numbers are king
vim.opt.relativenumber = true

-- Don't setup bufkill bindings, we use our own
vim.g.BufKillCreateMappings = 0

-- 8 Spaces for tabs is... a bit much
vim.opt.tabstop = 4

-- Whitespace display
vim.opt.listchars = "eol:¬,tab:>-,trail:~,extends:>,precedes:<,space:·"
vim.opt.list = true

-- Enable transparency by default
vim.g.transparent_enabled = true

-- require("my autocmds file") or just declare them here
