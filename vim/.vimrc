" Tony Lykke
" Borrows heavily from Douglas Black's .vimrc:
"     https://github.com/dougblack/dotfiles/blob/master/.vimrc
" Black is broken on work's vim, disable it temporarily until
" I can be bothered adding neovim appimage to this repo
" and running it instead of system vim:
" https://github.com/psf/black/issues/394
let g:pathogen_disabled = []
call add(g:pathogen_disabled, 'black')
execute pathogen#infect()

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

nnoremap <leader>c :SyntasticCheck<CR>:Errors<CR>
nnoremap <leader>1 :set number!<CR>
nnoremap <leader>d :GoDoc 
nnoremap <leader>t :TestFile<CR>
nnoremap <leader>r :call <SID>RunFile()<CR>
nnoremap <leader>b :call <SID>BuildFile()<CR>
vnoremap <leader>y "+y

" Abandon a buffer without closing the window/split
nnoremap <silent> <leader>q :BD<CR>
" }}}

" IDE stuff {{{
" Press F9 to run current file in a fresh terminal
nnoremap <F9> :!clear && %:p<Enter>
nnoremap <F10> :!clear && zsh<Enter><Enter>
" }}}

" Run Neomake on save {{{
" When writing a buffer (no delay).
call neomake#configure#automake('w')

" Gross hack to stop Neomake running when exitting because it creates a zombie cargo check process
" which holds the lock and never exits. But then, if you only have QuitPre, closing one pane will
" disable neomake, so BufEnter reenables when you enter another buffer.
let s:quitting = 0
au QuitPre *.rs let s:quitting = 1
au BufEnter *.rs let s:quitting = 0
au BufWritePost *.rs if ! s:quitting | Neomake | else | echom "Neomake disabled"| endif
let g:neomake_warning_sign = {'text': '?'}
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
set completeopt=menuone,noinsert,preview

" Select with enter instead of <C-Y>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Simulate down when the completion menu opens, so something is always
" selected.
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Use deoplete for completions
let g:deoplete#enable_at_startup = 1

" Use the venv for the jedi completion server
let g:deoplete#sources#jedi#python_path = $HOME."/.venvs/vim/bin/python"

" Show jedi dosctrings
let g:deoplete#sources#jedi#show_docstring = 1
" }}}

" Togglelist {{{
" Don't register the default bindings, they are already used for other things.
let g:toggle_list_no_mappings = 1

" Map them manually
nmap <script> <silent> <leader>l :call ToggleLocationList()<CR>
nmap <script> <silent> <leader>ll :call ToggleQuickfixList()<CR>
" }}}

" Syntastic {{{
let g:syntastic_python_flake8_args='--ignore=E501'
let g:syntastic_ignore_files = ['.java$']
let g:syntastic_python_python_exec = 'python3'
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
" Always show the status line
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme = 'bubblegum'

" Enable airline tabs
let g:airline#extensions#tabline#enabled = 1
" }}}

" Ctrl-Space {{{
set showtabline=0

" Neovim requires this
if has('nvim')
  let g:CtrlSpaceDefaultMappingKey = "<C-space> "
endif

" Arrows to navigate the pop-up please
let g:CtrlSpaceUseArrowsInTerm = 1

" Save workspaces automatically
let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceSaveWorkspaceOnExit = 1

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

