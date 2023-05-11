-- example file i.e lua/custom/init.lua

-- Relative numbers are king
vim.opt.relativenumber = true

-- Don't setup bufkill bindings, we use our own
vim.g.BufKillCreateMappings = 0

-- Whitespace display
vim.opt.listchars = "eol:¬,tab:>-,trail:~,extends:>,precedes:<,space:·"
vim.opt.list = true

-- Enable transparency by default
vim.g.transparent_enabled = true

vim.opt.backspace = "indent,eol,start"

-- Better display for messages
vim.opt.cmdheight = 2

-- Don't ring the bell or flash the window.
vim.opt.visualbell = true

-- utf8 encoding becuase it's 202x
vim.opt.encoding = "utf-8"

-- Use spaces for tabs
vim.opt.expandtab = true
-- 8 Spaces for tabs is... a bit much
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.modelines = 1

-- Hide buffers when they're abandoned
vim.opt.hid = true

-- Add a light-grey column at 88 (for Python) and 120 (for anything else)
vim.opt.colorcolumn = "88,120"
-- highlight ColorColumn ctermbg=0 guibg=deeppink4
vim.highlight.create("ColorColumn", {ctermbg = 0, guibg = "#3b4252"})

-- Search settings
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.magic = true

-- Always keep 15 lines below the cursor
vim.opt.scrolloff = 15

-- Show completion menu even when there's only one and don't insert
-- anything until enter is pressed.
vim.opt.completeopt = "menuone,noinsert,noselect"

vim.opt.signcolumn = "yes"
vim.g.gitgutter_sign_column_always = 1

-- autocommands
-- TODO move these to a separate file and require them
-- TODO this doesn't work, unsure why
vim.api.nvim_create_autocmd(
  {
    event = {"BufRead", "BufNewFile"},
    group = "filetypedetect",
    pattern = "Jenkinsfile",
    command = "set filetype=groovy",
  }
)
