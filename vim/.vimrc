" Tony Lykke

" Setup vim-plug
if has('nvim')
  call plug#begin(stdpath('data') . '/plugged')
else
  call plug#begin('~/.vim/plugged')
endif

" nvim 0.5+ native lsp
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'

" Nice tagbar (F8)
Plug 'majutsushi/tagbar'

" Colour themes
Plug 'sjl/badwolf'
Plug 'arcticicestudio/nord-vim'

" <3 fzf
Plug 'junegunn/fzf.vim'

" Nicer comment toggling
Plug 'preservim/nerdcommenter'

" Use :Tab to get nicer alignment of things
Plug 'godlygeek/tabular'

" Better tabline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Kill buffers without closing splits
Plug 'qpkorr/vim-bufkill'

" Nice icons
Plug 'ryanoasis/vim-devicons'

" git status in the gutter
Plug 'airblade/vim-gitgutter'

" Automatically generate tags
Plug 'ludovicchabant/vim-gutentags'

" Nicer indentation visuals (cause Python is bae)
Plug 'nathanaelkane/vim-indent-guides'

" Some indentation helpers
Plug 'michaeljsmith/vim-indent-object'

" Reopen files in the last place they were open
Plug 'farmergreg/vim-lastplace'

" Undo via a tree with diffs
Plug 'simnalamburt/vim-mundo'

" Make tmux panes and vim splits behave nicely
Plug 'christoomey/vim-tmux-navigator'

" Telescope for nice fuzzy finding
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" The future of code editing, they say
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Use LSP server for better completions
Plug 'nvim-lua/completion-nvim'
" Completions from TreeSitter
Plug 'nvim-treesitter/completion-treesitter'
" Completions from open buffers
Plug 'steelsojka/completion-buffers'

" A prettier LSP display, with some useful commands
Plug 'glepnir/lspsaga.nvim'

" Native LSP support for colour themes in error messages
Plug 'folke/lsp-colors.nvim'

" Initialize plugin system
" Must be done before the lua stuff below.
call plug#end()

" Setup the nvim 0.5 language server
if has('nvim')

lua << EOF
  -- config that activates keymaps and enables snippet support
  local function make_config()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return {
      -- enable snippet support
      capabilities = capabilities,
      -- map buffer local keybindings when the language server attaches
      on_attach = on_attach,
    }
  end

  -- lsp-install
  local function setup_servers()
    require'lspinstall'.setup()

    -- get all installed servers
    local servers = require'lspinstall'.installed_servers()

    for _, server in pairs(servers) do
      local config = make_config()

      -- language specific config
      --if server == "sourcekit" then
      --  config.filetypes = {"swift", "objective-c", "objective-cpp"}; -- we don't want c and cpp!
      --end

      require'lspconfig'[server].setup(config)
    end
  end

  -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
  require'lspinstall'.post_install_hook = function ()
    setup_servers() -- reload installed servers
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
  end

  -- keymaps
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
      buf_set_keymap("n", "<space>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
      buf_set_keymap("n", "<space>F", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
      vim.api.nvim_exec([[
      augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]], false)
    end
  end

  setup_servers()

  -- Setup lsp-saga
  require'lspsaga'.init_lsp_saga()
EOF

  " Some LSP Saga keymaps
  " LSP Saga keymaps
  nnoremap <silent> gf <cmd>lua require('lspsaga.provider').lsp_finder()<CR>
  nnoremap <silent><space>ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
  nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
  nnoremap <silent> gs <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
  nnoremap <silent><space>rn <cmd>lua require('lspsaga.rename').rename()<CR>
  nnoremap <silent> gd <cmd>lua require'lspsaga.provider'.preview_definition()<CR>
  " Toggle diagnostic on cursor.
  " Should this be enabled by default instead of a toggle?
  nnoremap <silent><space>e <cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>

  " Floating terminal
  nnoremap <silent><space>t <cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>
endif

" Encoding {{{
set encoding=utf-8
" }}}

" nvim exclusions {{{
if !has('nvim')
  " Pass through the keyboard shortcut for fullscreen to gVim
  map <silent> <F11>
  \    :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

  " Lose the menu bar
  set guioptions -=m
  " and the toolbar
  set guioptions -=T
  " and the scrollbar
  set guioptions -=r

  " Use a good font
  set guifont=FuraCode\ Nerd\ Font\ Mono
endif
" }}}

" Colours {{{
syntax enable           " enable syntax processing
set t_Co=256
" colorscheme badwolf
colorscheme nord
let g:nord_cursor_line_number_background = 1
let g:nord_bold_vertical_split_line = 1
let g:nord_italic_comments = 1
set termguicolors
" }}}

" Leader stuff {{{
" Spacebar leader, awwww yeah
" Need to remember to remap <Space> to a noop
" to avoid the infamous space-leader-delay issue.
let mapleader = " "
let g:mapleader = " "
nnoremap <SPACE> <Nop>

" Fast saving
map <Leader>w :w<CR>
" }}}

" TreeSitter
if has('nvim')
lua <<EOF
  require'nvim-treesitter.configs'.setup {
    indent = {
      enable = true
    }
  }
EOF
endif

" Misc {{{
set backspace=indent,eol,start
set noswapfile

" Better display for messages
set cmdheight=2

" Don't ring the bell or flash the window.
set visualbell
set t_vb=
" }}}


" Spaces & Tabs {{{
set tabstop=4           " 4 space tab
set expandtab           " use spaces for tabs
set softtabstop=4       " 4 space tab
set shiftwidth=4
set modelines=1
filetype indent on
filetype plugin on
set autoindent
" }}}

" UI Layout {{{
set number              " show line numbers
set showcmd             " show command in bottom bar
set nocursorline        " highlight current line

" Wildmenu settings
set wildmenu
set wildignore=*.o,*~,*.pyc,git\*,.hg\*,.svn\*

" Hide buffers when they are abandoned
set hid

" Use a mouse sometimes, even though it's blasphemy
if has('mouse')
  set mouse=a
  inoremap <LeftMouse> <Nop>
  inoremap <2-LeftMouse> <Nop>
  inoremap <3-LeftMouse> <Nop>
  inoremap <4-LeftMouse> <Nop>
  " Without this, mouse doesn't work across splits
  if !has('nvim')
    if has("mouse_sgr")
      set ttymouse=sgr
    else
      set ttymouse=xterm2
    end
  endif
endif

set lazyredraw
set ttyfast
set showmatch           " highlight matching parenthesis
set fillchars+=vert:┃
set relativenumber      " Default to relative line numbers

" Show whitespace chars
set listchars=eol:¬,tab:>-,trail:~,extends:>,precedes:<,space:·
set list

" highlight trailing space
highlight ExtraWhitespace ctermbg=darkmagenta guibg=darkmagenta
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Wrap more readably, on spaces instead of mid-word
set wrap linebreak

" Add a light-grey column at 88 (for Python) and 120 (for anything else)
set colorcolumn=88,120
" highlight ColorColumn ctermbg=0 guibg=deeppink4
highlight ColorColumn ctermbg=0 guibg=#3b4252
" }}}

" Searching {{{
set ignorecase
set infercase
set smartcase
set incsearch           " search as characters are entered
set hlsearch            " highlight all matches
set magic               " regex searching

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>
" }}}

" Folding {{{
"=== folding ===
set foldmethod=syntax   " fold based on language-specific syntax
set foldnestmax=10      " max 10 depth
set foldenable          " fold files by default on open
set foldlevelstart=10   " start with fold level of 10 so most everything isn't autofolded

" Line Shortcuts {{{
" This approach has the benefit of not breaking
" bulk line movement using the relative line numbers
" from the gutter.
" Source: https://stackoverflow.com/a/21000307/943833
nnoremap <expr> <silent>j v:count ? 'j' : 'gj'
nnoremap <expr> <silent> k v:count ? 'k' : 'gk'
nnoremap <silent> <Up> gk
nnoremap <silent> <Down> gj
nnoremap gV `[v`]

" 0 should go to first non-whitespace char
map 0 ^

" Allow shifting in visual mode without exiting it
vnoremap < <gv
vnoremap > >gv

" Always keep 15 lines below the cursor
set scrolloff=15
" }}}

" Spell checking {{{
" Toggle the spell checker
"map <leader>sp :set spell!<cr>

" Underline bad spellings
hi clear SpellBad
hi SpellBad cterm=underline,italic

" Use a spellfile that can be added and managed by this repo
set spellfile=~/.vim/spell/en.utf-8.add

" I'll die before I voluntarily drop the u from colour.
set spell spelllang=en_au
" }}}

" Leader Shortcuts {{{
nnoremap <leader>m :silent make\|redraw!\|cw<CR>
nnoremap <leader>h :A<CR>
nnoremap <leader>v :vsp $MYVIMRC<CR>
nnoremap <leader>z :vsp ~/.zshrc<CR>
nnoremap <leader>V :source $MYVIMRC<CR>
nnoremap <leader>0 :call <SID>ToggleNumber()<CR>

" Clear search highlighting
nnoremap <silent> <leader><CR> :let @/=""<CR>

" TODO make this use fzf with rg for that sweet sweet preview pane
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" Telescope config.
" See https://github.com/nvim-telescope/telescope.nvim
if has('nvim')
lua <<EOF
  require('telescope').setup{
    defaults = {
      color_devicons = true,
    }
  }
EOF
endif

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

nnoremap <leader>c :SyntasticCheck<CR>:Errors<CR>
nnoremap <leader>1 :set number!<CR>
vnoremap <leader>y "+y

" Abandon a buffer without closing the window/split
nnoremap <silent> <leader>q :BD<CR>
" }}}

" IDE stuff {{{
" Press F9 to run current file in a fresh terminal
nnoremap <F9> :!clear && %:p<Enter>
nnoremap <F10> :!clear && zsh<Enter><Enter>
" }}}

" Embedded terminal {{{
" Neovim terminal
augroup neovim_terminal
  autocmd!

  " Enter Terminal-mode (insert) automatically
  autocmd TermOpen * startinsert

  " Disables number lines on terminal buffers
  autocmd TermOpen * :set nonumber norelativenumber
augroup END
" }}}

" Tagbar {{{
" Use F8 to toggle Tagbar display
nmap <silent> <F8> :TagbarToggle<CR>
" Make sure that the tagbar is open, I don't really care what file
" is open.
call tagbar#autoopen(0)

" Auto-expand closed folds if the current tag is inside them
let g:tagbar_autoshowtag = 1
" }}}

" Gutentags {{{
let g:gutentags_cache_dir = "~/.cache/gutentags"

" Use rg to list files to tag
let g:gutentags_file_list_command = 'rg --files --hidden --follow --glob "!.git/*"'
" }}}

" Completion tweaks {{{
" Show completion menu even when there's only one and don't insert
" anything until enter is pressed.
set completeopt=menuone,noinsert,noselect

" Register completion sources
let g:completion_chain_complete_list = [
    \{'complete_items': ['lsp', 'buffers']}
\]

if has('nvim')
  " Enable completion in all buffers, regardless of LSP presence
  autocmd BufEnter * lua require'completion'.on_attach()
endif

" Auto change sources when the first one doesn't have any matches
let g:completion_auto_change_source = 1

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)

" Avoid showing message extra message when using completion
set shortmess+=c

" Don't show function signatures, I don't find them useful
" let g:completion_enable_auto_signature = 0

" Use smart case matching
let g:completion_matching_smart_case = 1

" Auto-close the preview window when moving
autocmd CursorMovedI * if pumvisible() == 0|silent! pclose|endif
autocmd InsertLeave * if pumvisible() == 0|silent! pclose|endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" JSONC comment formatting {{{
  autocmd FileType json syntax match Comment +\/\/.\+$+
" }}}

" Togglelist {{{
" Don't register the default bindings, they are already used for other things.
let g:toggle_list_no_mappings = 1

" Map them manually
nmap <script> <silent> <leader>l :call ToggleLocationList()<CR>
nmap <script> <silent> <leader>ll :call ToggleQuickfixList()<CR>
" }}}

" NERDTree {{{
" Close vim if the last thing left open is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Always change the nerdtree cwd to the current nerdtree root
let g:NERDTreeChDirMode = 2

" Let wildignore tell us what to ignore.
" The fugitive gitignore extension automatically imports .gitignore
" for a project, so this makes nerdtree ignore things in gitignore.
let NERDTreeRespectWildIgnore = 1
" }}}

" NerdCommenter {{{
let g:NERDTrimTrailingWhitespace = 1
let g:NERDDefaultAlign = 'left'
let g:NERDSpaceDelims = 1
let g:NERDToggleCheckAllLines = 1
" Don't use default mappings, the only commenting I need is clever Ctrl+/ that
" we map below.
let g:NERDCreateDefaultMappings = 0
" For whatever reason, <C-_> is actually Ctrl+/.
" Nice, intuitive comment toggle keymap.
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv
" }}}

" Icons {{{
let g:webdevicons_enable = 1
" }}}

" git-gutter {{{
if exists('&signcolumn')  " Vim 7.4.2201
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif
" }}}

" AutoGroups {{{
augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md,*.rb :call <SID>StripTrailingWhitespaces()
    autocmd BufEnter *.cls setlocal filetype=java
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
    autocmd BufEnter *.py setlocal tabstop=4
    autocmd BufEnter *.md setlocal ft=markdown
    autocmd BufEnter *.go setlocal noexpandtab
    autocmd BufEnter *.avsc setlocal ft=json
augroup END

" Automatically close floaterm after it exits.
" The *:$SHELL means it only closes terminals, not other subcommands.
" Adapted from, with ok condition removed: https://vi.stackexchange.com/a/17388
func! s:afterTermClose() abort
  " TODO is there a way to detect whether it's a floatterm?
  bdelete!
  bdelete!
endfunc

augroup floatterm
  autocmd!
  " The line '[Process exited ?]' is appended to the terminal buffer after the
  " `TermClose` event. So we use a timer to wait a few milliseconds to read the
  " exit status. Setting the timer to 0 or 1 ms is not sufficient; 20 ms seems
  " to work for me.
  autocmd TermClose *:$SHELL call timer_start(20, { -> s:afterTermClose() })
augroup END
" }}}

" Testing {{{
let test#strategy = 'neovim'
" }}}

" Backups {{{
set nobackup
" }}}

" Sessions {{{
if !has('nvim')
  " Remember things between sessions
  " This is only necessary outside nvim, which automatically
  " remembers a bunch of this stuff, yay sane defaults!
  " '20  - remember marks for 20 previous files
  " \"50 - save 50 lines for each register
  " :20  - remember 20 items in command-line history
  " /20  - remember 20 items in search history
  " %    - remember the buffer list (if vim started without a file arg)
  " n    - set name of viminfo file
  set viminfo='20,\"50,:20,/20,%,n~/.viminfo
endif

" Define what to save with :mksession
" blank    - empty windows
" buffers  - all buffers not only ones in a window
" curdir   - the current directory
" folds    - including manually created ones
" help     - the help window
" options  - all options and mapping
" winsize  - window sizes
" tabpages - all tab pages
set sessionoptions=blank,buffers,curdir,folds,help,options,winsize,tabpages
" }}}

" airline {{{
" Always show the status line
set laststatus=2
let g:airline_powerline_fonts = 1
" let g:airline_theme = 'bubblegum'
let g:airline_theme = 'nord'

" Enable airline tabs
let g:airline#extensions#tabline#enabled = 1

" Use highlighting cache
let g:airline_highlighting_cache = 1
" }}}

" Ctrl-Space {{{
set showtabline=0

" Disable airline preview to avoid status bar conflicts
let g:airline_exclude_preview = 1

" Store the cache dir in the .cache dir
let g:CtrlSpaceCacheDir = $HOME."/.cache/vim/ctrlspace"

" Use rg if it's installed
" TODO figure out the incantation for fzf with preview and rg instead
if executable("rg")
    let g:CtrlSpaceGlobCommand = 'rg -l --hidden --follow --glob "!.git/*" -g ""'
endif
" }}}

" mundo {{{
set undofile
set undodir=~/.cache/vim/undo
noremap <leader>u :MundoToggle<CR>
" }}}

" fzf {{{
set rtp+=~/.fzf
" }}}

" Copy/Paste {{{
set clipboard+=unnamedplus

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
" }}}

" autocorrect {{{
augroup litecorrect
  autocmd!
  autocmd FileType markdown,mkd call litecorrect#init()
  autocmd FileType textile call litecorrect#init()
augroup END
" }}}

" splits {{{
" Use Alt+Arrows to move around, same as my tmux config
" TODO maybe use neovim shell instead of tmux?
" nnoremap <A-Down> <C-W><C-J>
" nnoremap <A-Up> <C-W><C-K>
" nnoremap <A-Right> <C-W><C-L>
" nnoremap <A-Left> <C-W><C-H>
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <A-Left> :TmuxNavigateLeft<cr>
nnoremap <silent> <A-Down> :TmuxNavigateDown<cr>
nnoremap <silent> <A-Up> :TmuxNavigateUp<cr>
nnoremap <silent> <A-Right> :TmuxNavigateRight<cr>
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1
" }}}


" Change default split location to bottom right
set splitbelow
set splitright
" }}}

" autoformatting {{{
" Only try to black if black is loaded
if globpath(&runtimepath, "black", 1) !=# ''
    autocmd FileType python autocmd BufWritePre <buffer> :Black
endif

" Enable rust auto-formatting
let g:rustfmt_autosave = 1

" Setup gutentags to use rusty-tags
if !exists("g:gutentags_project_info")
  let g:gutentags_project_info = []
endif
call add(g:gutentags_project_info, {'type': 'rust', 'file': 'Cargo.toml'})
let g:gutentags_ctags_executable_rust = $HOME.'/.vim/shims/rusttags.sh'
" }}}

" Rust {{{
let g:racer_cmd = $HOME."/.cargo/bin/racer"

" Include full function def, args, and return type in completions
let g:racer_experimental_completer = 1

" Insert parens when completing functions and other things that need them
let g:racer_insert_paren = 1

" 4 spaces please
autocmd FileType rust setlocal shiftwidth=4 tabstop=4
autocmd FileType rust setlocal expandtab

" Some nice mappings for useful shortcuts
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)
" }}}

" markdown {{{
let g:vim_markdown_toml_frontmatter = 1
" }}}

" tmux {{{
" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
" }}}

" Custom Functions {{{
function! <SID>ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" strips trailing whitespace at the end of files. This
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunc

function! <SID>CleanFile()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %!git stripspace
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunc

" }}}

" vim:foldmethod=marker:foldlevel=0

