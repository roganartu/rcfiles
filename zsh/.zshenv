export EDITOR=~/bin/nvim
export VISUAL=$EDITOR
skip_global_compinit=1

# Cargo bin path for Rust things
export PATH="$HOME/.cargo/bin:$PATH"

# emacs doom path
export PATH="$PATH:$HOME/.emacs.d/bin"
. "$HOME/.cargo/env"

# pip install dir
export PATH="$PATH:$HOME/.local/bin"
