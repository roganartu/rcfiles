if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export EDITOR=/usr/bin/vim
export VISUAL=$EDITOR
skip_global_compinit=1
