
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  git clone git@github.com:ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh
fi

export ZSH=$HOME/.oh-my-zsh

if [ ! -e "$HOME/.zplug/init.zsh" ]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

if [ ! -e "$HOME/.tmux/plugins/tpm" ]; then
  mkdir -p ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ ! -e "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

source ~/.zplug/init.zsh

if ! zplug check; then
  zplug install
fi

if [[ -z "$WSLENV" ]]; then
  # Load this when you're not in WSL
  zplug "zsh-users/zsh-completions"
  zplug "zsh-users/zsh-autosuggestions"
else
  # Load this when you ARE in WSL

  export OLD_PATH=$PATH
  export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/Users/nick/.oh-my-posh:/mnt/c/Users/nick/AppData/Local/Programs/Microsoft\ VS\ Code/bin
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

if command -v nvim &> /dev/null; then
  export EDITOR=nvim

  alias vim='nvim'
  alias vimrc='nvim ~/.config/nvim/init.vim'

  if [ ! -e "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]; then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  fi

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

. "$HOME/.cargo/env"

zplug load

#export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
