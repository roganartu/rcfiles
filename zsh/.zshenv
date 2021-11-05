export EDITOR=~/bin/nvim
export VISUAL=$EDITOR
skip_global_compinit=1

# Cargo bin path for Rust things
export PATH="$HOME/.cargo/bin:$PATH"
. "$HOME/.cargo/env"

# emacs doom path
export PATH="$PATH:$HOME/.emacs.d/bin"

# pip install dir
export PATH="$PATH:$HOME/.local/bin"
# lwsm is installed in some old npm
PATH=$PATH:/home/tl/.nvm/versions/node/v11.11.0/bin

# Make sure ZOOM is namespaced
export ZOOM_HOME=${HOME}/zoomus
mkdir -p ${HOME}/zoomus
