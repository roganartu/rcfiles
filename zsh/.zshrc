# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

DEFAULT_USER=$USER

zstyle ':completion:*' completer _expand _complete _ignored _correct
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' ignore-parents parent pwd .. directory
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %S%l: Hit TAB for more%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' max-errors 5
zstyle ':completion:*' menu select=1
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling: %l%s
zstyle ':completion:*' substitute 1
zstyle :compinstall filename $HOME'/.zshrc'

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

plugins=(poetry)

# Don't background processes because nice doesn't work in WSL
if uname -r | grep -q 'Microsoft' ; then
  unsetopt BG_NICE
fi

# User configuration

HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=100000
setopt appendhistory autocd beep nomatch notify
bindkey -v

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
# Don't modify the prompt when we are in a venv, starship already does this for us
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
if command -v pyenv 1>/dev/null 2>&1; then
  # Only init pyenv if we're not already in a venv
  if [[ -z "$VIRTUAL_ENV" ]]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" 2>&1 >/dev/null

# Force tmux to use 256 colours
alias tmux="TERM=xterm-256color tmux -2"

# Use neovim instead of vim.
# This has to handle Windows, where FUSE isn't available.
if nvim --version &> /dev/null ]]; then
  alias vim="~/bin/nvim"
else
  alias vim="~/bin/nvim-extracted"
fi

# Some overrides
# start typing + [Up-Arrow] - fuzzy find history forward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
# bindkey "^[[A" up-line-or-beginning-search
bindkey "$key[Up]" up-line-or-beginning-search
# start typing + [Down-Arrow] - fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
# bindkey "^[[B" down-line-or-beginning-search
bindkey "$key[Down]" down-line-or-beginning-search
bindkey '^[[Z' reverse-menu-complete

if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey -M viins "${terminfo[khome]}" beginning-of-line   # [Home] - Go to beginning of line
  bindkey -M vicmd "${terminfo[khome]}" beginning-of-line   # Need to specify vi-mode
fi
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey -M viins "${terminfo[kend]}"  end-of-line         # [End] - Go to end of line
  bindkey -M vicmd "${terminfo[kend]}"  end-of-line         # Need to specify vi-mode
fi
if [[ "${terminfo[kdch1]}" != "" ]]; then
  bindkey -M viins "${terminfo[kdch1]}"  delete-char        # [Del] - Delete char
  bindkey -M vicmd "${terminfo[kdch1]}"  delete-char        # Need to specify vi-mode
fi

# Fuck ansible cowsay off
export ANSIBLE_NOCOWS=1

export GOPATH=~/Code/go
export PATH=$PATH:$GOPATH/bin

export PATH=~/bin:$PATH

if uname -r | grep -q 'Microsoft' ; then
  # vscode binary
  export PATH=$PATH:'/mnt/c/Program Files/Microsoft VS Code/bin'

  # ConEmu doesn't really play nice with shells, so force everything to think we're ZSH
  export SHELL=/usr/bin/zsh
fi

# Run ssh-agent as a systemd unit, per:
# https://stackoverflow.com/a/38980986
if [ -z "$SSH_AUTH_SOCK" ] && [ -r "$XDG_RUNTIME_DIR/ssh-agent.socket" ]; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi
# Linux cmd to start keychain
# --noask prevents this from prompting until the key is first used.
# --inherit any makes it respect SSH_AUTH_SOCK running in systemd, as set above.
eval `keychain -q --eval id_rsa --noask --inherit any`

# Don't fucking beep
unsetopt beep

# FZF stuff
# export FZF_DEFAULT_OPTS=$FZT_DEFAULT_OPS'
# --color fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C
# --color pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B'
_gen_fzf_default_opts() {
  local base03="234"
  local base02="235"
  local base01="240"
  local base00="241"
  local base0="244"
  local base1="245"
  local base2="254"
  local base3="230"
  local yellow="136"
  local orange="166"
  local red="160"
  local magenta="125"
  local violet="61"
  local blue="33"
  local cyan="37"
  local green="64"

  # Solarized Dark color scheme for fzf
  export FZF_DEFAULT_OPTS="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
  "
}
_gen_fzf_default_opts
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# jq repl with fzf
ijq() {
    echo '' | fzf --print-query --preview "cat $* | jq -C {q}"
}

# Handy alias for reloading all tmux windows (which reloads zshrc everywhere)
alias reload-tmux="tmux display -p '#S' | xargs -I{} sh -c \"tmux list-windows -t {} | cut -d: -f1 | xargs -P0 -I\[\] tmux respawn-pane -kt {}:\[\]\""

# Include a local zsh overrides file if it's present.
# This isn't checked in, and is useful for my current employer
# who doesn't like things related to their environment
# being released without permission.
if [ -f ~/.zshrc-overrides ]; then
    . ~/.zshrc-overrides
fi

# Don't auto-suggest for long strings
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
# Be the async you want to see
ZSH_AUTOSUGGEST_USE_ASYNC=1

source ~/.zsh/systemd/aliases.zsh

# Add zsh-completions to fpath
fpath=(~/.zsh/zsh-completions/src $fpath)

# Load completions
autoload -U compinit && compinit

# Must be last so it can wrap all custom zle widgets
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Use starship.rs
eval "$(starship init zsh)"

autoload -Uz compinit
fpath+=~/.zfunc
