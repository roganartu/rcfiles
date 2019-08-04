# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

DEFAULT_USER=$USER

ZSH_THEME=""

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    gitfast
    python
    safe-paste
    colorize
    extract
    docker
    copyfile
    command-not-found
    history
    kubectl
    pip
    pyenv
    sudo
    systemd
    web-search
    wd
    vi-mode
)

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

# Pure stuff
# change the path color
zstyle :prompt:pure:path color white
PURE_PROMPT_SYMBOL=">"
PURE_PROMPT_VICMD_SYMBOL="<"
PURE_GIT_DOWN_ARROW="(behind)"
PURE_GIT_UP_ARROW="(ahead)"

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

source $ZSH/oh-my-zsh.sh

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
bindkey '^R' history-incremental-search-backward

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

# pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" 2>&1 >/dev/null

# Force tmux to use 256 colours
alias tmux="TERM=xterm-256color tmux -2"

# Some overrides
# start typing + [Up-Arrow] - fuzzy find history forward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
# start typing + [Down-Arrow] - fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
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

# Use bat if it's available, else fallback to cat
_bat_if_present() {
    which bat 2>&1 > /dev/null
    if [ $? -ne 0 ]; then
        # Bat isn't available, use cat
        /bin/cat "$@"
    else
        # Yay bat is way nicer
        bat "$@"
    fi
}
alias cat=_bat_if_present

# Fuck ansible cowsay off
export ANSIBLE_NOCOWS=1

export GOPATH=~/Code/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

export PATH=$PATH:~/bin

if uname -r | grep -q 'Microsoft' ; then
  # vscode binary
  export PATH=$PATH:'/mnt/c/Program Files/Microsoft VS Code/bin'

  # ConEmu doesn't really play nice with shells, so force everything to think we're ZSH
  export SHELL=/usr/bin/zsh
fi

ssh-add -A  &> /dev/null

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

  # Comment and uncomment below for the light theme.

  # Solarized Dark color scheme for fzf
  export FZF_DEFAULT_OPTS="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
  "
}
_gen_fzf_default_opts
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Include a local zsh overrides file if it's present.
# This isn't checked in, and is useful for my current employer
# who doesn't like things related to their environment
# being released without permission.
if [ -f ~/.zshrc-overrides ]; then
    . ~/.zshrc-overrides
fi

# Use pure prompt
# Must be after the oh-my-zsh sourcing
fpath=("$HOME/.zsh/functions" $fpath)
autoload -U promptinit; promptinit
prompt pure

# Don't auto-suggest for long strings
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
# Be the async you want to see
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Must be last so it can wrap all custom zle widgets
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
