
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  git clone git@github.com:ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh
fi

export ZSH=$HOME/.oh-my-zsh

if [ ! -e "$HOME/.zplug/init.zsh" ]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

source ~/.zplug/init.zsh

if ! zplug check; then
  zplug install
fi

if [[ -z "$WSLENV" ]]; then
  # Load these when you're not in WSL
  zplug "zsh-users/zsh-completions"
  zplug "zsh-users/zsh-autosuggestions"
else
  # LOad these when you ARE in WSL
fi

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "mafredri/zsh-async", from:github, use:"async.zsh"
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

export ZSH_THEME=""

autoload -Uz compinit
compinit

autoload -Uz promptinit
promptinit

zstyle ':omz:plugins:nvm' lazy yes

# Full list of Oh My Zsh plugins:
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
plugins=(
  #ssh-agent
  git
  #dotenv
  #archlinux
  common-aliases
  #rust
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

if command -v nvim &> /dev/null; then
  export EDITOR=nvim

  alias vim='nvim'
  alias vimrc='nvim ~/.config/nvim/init.vim'

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
else
  export EDITOR=vim
fi

bindkey "^[[H"    beginning-of-line
bindkey "^[[F"    end-of-line
bindkey "^[[3~"   delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

zplug load

#export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
