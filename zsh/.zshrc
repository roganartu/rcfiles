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
PURE_PROMPT_SYMBOL="➜"
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

# pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" 2>&1 >/dev/null

# Some overrides
# start typing + [Up-Arrow] - fuzzy find history forward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
# start typing + [Down-Arrow] - fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line      # [Home] - Go to beginning of line
fi
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}"  end-of-line            # [End] - Go to end of line
fi

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

# Use pure prompt
# Must be after the oh-my-zsh sourcing
fpath=("$HOME/.zsh/functions" $fpath)
autoload -U promptinit; promptinit
prompt pure

# Must be last so it can wrap all custom zle widgets
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
