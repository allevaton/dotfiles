source ~/.profile

export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh

NVM_LAZY=1
ZSH_AUTOSUGGEST_USE_ASYNC=1

ZSH_THEME=""

if command -v rg > /dev/null ; then
  export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
fi

plugins=(
  git
  #docker
  #docker-compose
  sudo
  nvm
  z
  zsh-completions
  zsh-autosuggestions
  rsync
  yarn
  colored-man-pages
  aws
)

source $ZSH/oh-my-zsh.sh

fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

bindkey "[C" emacs-forward-word   #control left
bindkey "[D" backward-word        #control right

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls -h --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
else
  alias ls='ls -h'
fi

alias ll='ls -lF'
alias la='ls -lA'
alias l='ls'

if command -v nvim > /dev/null ; then
  export EDITOR=nvim

  alias vim='nvim'
  alias vimrc='nvim ~/.config/nvim/init.vim'
else
  alias vimrc='vim ~/.vimrc'
fi


