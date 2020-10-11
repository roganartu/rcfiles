" Use the vim venv created by the makefile
let g:python_host_prog = $HOME."/.venvs/vim_py2/bin/python"
let g:python3_host_prog = $HOME."/.venvs/vim/bin/python"

" Encoding {{{
set encoding=utf-8
" }}}

" Colours {{{
syntax enable           " enable syntax processing
set t_Co=256
colorscheme badwolf
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

" Misc {{{
set backspace=indent,eol,start
set noswapfile

" Better display for messages
set cmdheight=2
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

" Hide buffers when they are abandoned
set hid

set lazyredraw
set ttyfast
set showmatch           " highlight matching parenthesis
set fillchars+=vert:┃
set relativenumber      " Default to relative line numbers

" Wrap more readably, on spaces instead of mid-word
set wrap linebreak

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
map <leader>ss :set spell!<cr>

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
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>V :source $MYVIMRC<CR>
nnoremap <leader>0 :call <SID>ToggleNumber()<CR>

" Clear search highlighting
nnoremap <silent> <leader><CR> :let @/=""<CR>

" TODO make this use fzf with rg for that sweet sweet preview pane
nnoremap <leader>f :Rg 

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

nnoremap <leader>1 :set number!<CR>
vnoremap <leader>y "+y

" Abandon a buffer without closing the window/split
nnoremap <silent> <leader>q :call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
" }}}

if filereadable("/home/tl/.nvm/versions/node/v12.10.0/bin/node")
  let g:coc_node_path = "/home/tl/.nvm/versions/node/v12.10.0/bin/node"
endif

" gotos
" TODO map these to the vscode versions
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" Remap for rename current word
" TODO map to vscode version
" nmap <leader>rn <Plug>(coc-rename)

" Icons {{{
let g:webdevicons_enable = 1
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
" }}}

" Backups {{{
set nobackup
" }}}

" Use rg if it's installed
" TODO figure out the incantation for fzf with preview and rg instead
if executable("rg")
    let g:CtrlSpaceGlobCommand = 'rg -l --hidden --follow --glob "!.git/*" -g ""'
endif
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

" splits {{{
" Use Alt+Arrows to move around, same as my tmux config
" TODO set these to vscode versions
" nnoremap <A-Down> <C-W><C-J>
" nnoremap <A-Up> <C-W><C-K>
" nnoremap <A-Right> <C-W><C-L>
" nnoremap <A-Left> <C-W><C-H>

" Change default split location to bottom right
set splitbelow
set splitright
" }}}

" 4 spaces please
autocmd FileType rust setlocal shiftwidth=4 tabstop=4
autocmd FileType rust setlocal expandtab

" Some nice mappings for useful shortcuts
" TODO map to vscode versions
" au FileType rust nmap gd <Plug>(rust-def)
" au FileType rust nmap gs <Plug>(rust-def-split)
" au FileType rust nmap gx <Plug>(rust-def-vertical)
" au FileType rust nmap <leader>gd <Plug>(rust-doc)
" }}}

" markdown {{{
let g:vim_markdown_toml_frontmatter = 1
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
