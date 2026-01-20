if [ ! -d "$HOME/.oh-my-zsh" ]; then
  git clone https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh
fi

export ZSH=$HOME/.oh-my-zsh

if [ ! -e "$HOME/.zplug/init.zsh" ]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

if [ ! -e "$HOME/.tmux/plugins/tpm" ]; then
  mkdir -p ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

source ~/.zplug/init.zsh

if ! command -v fzf &> /dev/null; then
  sudo pacman -S fzf
fi

if [[ -z "$WSL_DISTRO_NAME" ]]; then
  # Load this when you're not in WSL
else
  # Load this when you ARE in WSL

  eval "$(/usr/sbin/wsl2-ssh-agent)"

  export OLD_PATH=$PATH
  export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/Users/allev/.oh-my-posh:/mnt/c/Users/allev/AppData/Local/Programs/Microsoft\ VS\ Code/bin:/mnt/c/Windows/System32:/mnt/c/Windows:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/
fi

if ! command -v pygmentize &> /dev/null; then
  echo "pygmentize not found. Installing..."
  sudo pacman -S python-pygments
fi

zplug "mafredri/zsh-async", from:github, defer:0, at:main
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "catppuccin/zsh-syntax-highlighting", at:main
zplug "zsh-users/zsh-syntax-highlighting", from:github, defer:3
zplug load

export ZSH_THEME=""

# Full list of Oh My Zsh plugins:
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
plugins=(
  git
  common-aliases
  sudo
  colored-man-pages
  nvm
  z
  fzf
  virtualenv
  uv
)

function psgrep() {
  ps aux | { head -1; grep "$@"; }
}

#zstyle :omz:plugins:ssh-agent agent-forwarding on
#zstyle :omz:plugins:ssh-agent identities id_ed25519

source $ZSH/oh-my-zsh.sh

alias lg='lazygit'

alias ls='ls -h --color=auto --group-directories-first'
alias l='ls'
alias ll='ls -hal'

if command -v nvim &> /dev/null; then
  export EDITOR=nvim

  alias vim='nvim'
  alias vimrc='nvim ~/.config/nvim'
  alias vimrcp='nvim ~/.config/nvim/lua/plugins.lua'
  alias vimrcl='nvim ~/.config/nvim/lua/lsp.lua'
else
  export EDITOR=vim
fi

bindkey "^[[H"    beginning-of-line
bindkey "^[[F"    end-of-line
bindkey "^[[3~"   delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

export PATH=~/.local/bin:/usr/local/cuda-12.3/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-12.3/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

eval "$(starship init zsh)"
