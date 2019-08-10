set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Use the vim venv created by the makefile
let g:python_host_prog = "$HOME/.venvs/vim_py2/bin/python"
let g:python3_host_prog = "$HOME/.venvs/vim/bin/python"
