" Tony Lykke
" Borrows heavily from Douglas Black's .vimrc:
"     https://github.com/dougblack/dotfiles/blob/master/.vimrc
execute pathogen#infect()

" Encoding {{{
set encoding=utf-8
" }}}

" Colors {{{
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
set clipboard=unnamed
set noswapfile
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

" Wrap when moving left/right at EOL/BOL
set whichwrap+=<,>,h,l,[,]

" Use a mouse sometimes, even though it's blasphemy
if has('mouse')
  set mouse=a
  inoremap <LeftMouse> <Nop>
  inoremap <2-LeftMouse> <Nop>
  inoremap <3-LeftMouse> <Nop>
  inoremap <4-LeftMouse> <Nop>
  " Without this, mouse doesn't work across splits
  if has("mouse_sgr")
      set ttymouse=sgr
  else
      set ttymouse=xterm2
  end
endif

set lazyredraw
set showmatch           " higlight matching parenthesis
set fillchars+=vert:┃
set relativenumber      " Default to relative line numbers

" Show whitespace chars
set listchars=eol:¬,tab:>-,trail:~,extends:>,precedes:<,space:·
set list

" highlight trailing space
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Wrap more readably, on spaces instead of mid-word
set wrap linebreak

" Add a light-grey column at 88 (for Python) and 120 (for anything else)
set colorcolumn=88,120
highlight ColorColumn ctermbg=0 guibg=deeppink4
" }}}

" Searching {{{
set ignorecase
set infercase
set smartcase
set incsearch           " search as characters are entered
set hlsearch            " highlight all matches
set magic               " regex searching

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>
" }}}

" Folding {{{
"=== folding ===
set foldmethod=indent   " fold based on indent level
set foldnestmax=10      " max 10 depth
set foldenable          " don't fold files by default on open
set foldlevelstart=10   " start with fold level of 1
" }}}

" Line Shortcuts {{{
" This approach has the benefit of not breaking
" bulk line movement using the relative line numbers
" from the gutter.
" Source: https://stackoverflow.com/a/21000307/943833
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
nnoremap <Up> gk
nnoremap <Down> gj
nnoremap gV `[v`]

" 0 should go to first non-whitespace char
map 0 ^

" Allow shifting in visual mode without exiting it
vnoremap < <gv
vnoremap > >gv
" }}}

" Spell checking {{{
" Toggle the spell checker
map <leader>ss :setlocal spell!<cr>

" Underline bad spellings
hi clear SpellBad
hi SpellBad cterm=underline,italic
" }}}

" Leader Shortcuts {{{
nnoremap <leader>m :silent make\|redraw!\|cw<CR>
nnoremap <leader>h :A<CR>
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>l :call <SID>ToggleNumber()<CR>

" Clear search highlighting
nnoremap <silent> <leader><CR> :noh<CR>

" TODO make this use fzf with rg
nnoremap <leader>f :Rg 

nnoremap <leader>c :SyntasticCheck<CR>:Errors<CR>
nnoremap <leader>1 :set number!<CR>
nnoremap <leader>d :GoDoc 
nnoremap <leader>t :TestFile<CR>
nnoremap <leader>r :call <SID>RunFile()<CR>
nnoremap <leader>b :call <SID>BuildFile()<CR>
vnoremap <leader>y "+y
" }}}

" IDE stuff {{{
" Press F9 to run current file in a fresh terminal
nnoremap <F9> :!clear && %:p<Enter>
nnoremap <F10> :!clear && zsh<Enter><Enter>
" }}}

" CtrlP {{{
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = '\vbuild/|dist/|venv/|target/|\.(o|swp|pyc|egg)$'
let g:ctrlp_map = '<c-o>'
" }}}

" Syntastic {{{
let g:syntastic_python_flake8_args='--ignore=E501'
let g:syntastic_ignore_files = ['.java$']
let g:syntastic_python_python_exec = 'python3'
" }}}

" NerdCommenter {{{
let g:NERDTrimTrailingWhitespace = 1
let g:NERDDefaultAlign = 'left'
let g:NERDSpaceDelims = 1
let g:NERDToggleCheckAllLines = 1
" For whatever reason, <C-_> is actually Ctrl+/.
" Nice, intuitive comment toggle keymap.
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv
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
" }}}

" Testing {{{
let test#strategy = 'neovim'
let test#python#runner = 'nose'
" }}}

" Backups {{{
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup
" }}}

" Sessions {{{
" Remember things between sessions
" '20  - remember marks for 20 previous files 
" \"50 - save 50 lines for each register 
" :20  - remember 20 items in command-line history 
" /20  - remember 20 items in search history 
" %    - remember the buffer list (if vim started without a file arg) 
" n    - set name of viminfo file
set viminfo='20,\"50,:20,/20,%,n~/.viminfo

nnoremap <leader>s :mksession<CR>

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
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme = 'bubblegum'
" }}}

" mundo {{{
set undofile
set undodir=~/.cache/vim/undo
noremap <leader>u :MundoToggle<CR>
" }}}

" fzf {{{
set rtp+=~/.fzf
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
nnoremap <A-Down> <C-W><C-J>
nnoremap <A-Up> <C-W><C-K>
nnoremap <A-Right> <C-W><C-L>
nnoremap <A-Left> <C-W><C-H>

" Change default split location to bottom right
set splitbelow
set splitright
" }}}

" autoformatting {{{
autocmd FileType python autocmd BufWritePre <buffer> :Black
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

" strips trailing whitespace at the end of files. this
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

function! <SID>RunFile()
    let ext = expand("%:e")
    if(ext == "go") 
        :GoRun
    endif
endfunc

function! <SID>BuildFile()
    let ext = expand("%:e")
    if(ext == "go") 
        :GoBuild
    endif
endfunc
" }}}

" vim:foldmethod=marker:foldlevel=0

