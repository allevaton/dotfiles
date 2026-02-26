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
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install fzf
  else
    sudo pacman -S fzf
  fi
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
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install pygments
  else
    sudo pacman -S python-pygments
  fi
fi

zplug "mafredri/zsh-async", from:github, defer:0, at:main
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
#zplug "catppuccin/zsh-syntax-highlighting", at:main
zplug "zsh-users/zsh-syntax-highlighting", from:github, defer:3
zplug load

# Disabled: theme colors path separators red
#source ~/.zplug/repos/catppuccin/zsh-syntax-highlighting/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh

#ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#cad3f5,underline'
#ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#cad3f5,underline'

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

#zstyle :omz:plugins:ssh-agent agent-forwarding on
#zstyle :omz:plugins:ssh-agent identities id_ed25519

zstyle ':omz:plugins:nvm' lazy yes
source $ZSH/oh-my-zsh.sh

alias lg='lazygit'

# Override oh-my-zsh's cyan directories with Catppuccin blue (ANSI 34)
export LSCOLORS="Exfxcxdxbxegedabagacad"
export LS_COLORS="di=1;34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

export EZA_IGNORE_GLOB=".DS_Store|Thumbs.db|__pycache__|*.pyc|.mypy_cache"

alias ls='eza --group-directories-first'
alias ll='eza -la --group-directories-first --git'
alias lt='eza --tree --level=2 --group-directories-first -I="node_modules|.git|.idea|.vscode|.next|.cache"'
alias l='ls'

function psgrep() {
  ps aux | { head -1; grep "$@"; }
}

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

export PATH=~/.local/bin${PATH:+:${PATH}}
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
  alias python='python3'
  alias pip='pip3'
else
  export PATH=/usr/local/cuda-12.3/bin${PATH:+:${PATH}}
  export LD_LIBRARY_PATH=/usr/local/cuda-12.3/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
fi

eval "$(starship init zsh)"
