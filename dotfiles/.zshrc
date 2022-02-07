if [ -d "$HOME/.oh-my-zsh" ]; then
  export ZSH=$HOME/.oh-my-zsh
else
  export ZSH=/usr/share/oh-my-zsh
fi

if [ ! -e "$HOME/.zplug/init.zsh" ]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

source ~/.zplug/init.zsh

#zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

export ZSH_THEME=""

if command -v nvim > /dev/null; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

autoload -Uz compinit
compinit

autoload -Uz promptinit
promptinit

#NVM_LAZY=1

# Full list of Oh My Zsh plugins:
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
plugins=(
  #ssh-agent
  git
  #dotenv
  archlinux
  common-aliases
  rust
  nvm
  yarn
  sudo
  aws
  colored-man-pages
  #safe-paste
  z
  fzf
)

function psgrep() {
  ps aux | { head -1; grep "$@"; }
}

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_ed25519

source $ZSH/oh-my-zsh.sh

alias lg='lazygit'

alias ls='ls -h --color=auto --group-directories-first'
alias l='ls'
alias ll='ls -hal'

alias vim='nvim'
alias vimrc='nvim ~/.config/nvim/init.vim'

bindkey "^[[H"    beginning-of-line
bindkey "^[[F"    end-of-line
bindkey "^[[3~"   delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

zplug load

#export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
