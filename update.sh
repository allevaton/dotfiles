#!/usr/bin/env bash

### ZSH itself
echo Checking zsh...
if ! command -v zsh > /dev/null ; then
  sudo apt install zsh
  chsh -s /bin/zsh
fi

### Oh My Zsh
echo Checking oh my zsh...
if [ -d ~/.oh-my-zsh ]; then
  git -C ~/.oh-my-zsh pull
else
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo Checking fzf...
if [ -d ~/.fzf ]; then
  git -C ~/.fzf pull
else
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
fi

### Pure Prompt
echo Checking Pure Prompt...
if [ -d ~/.zsh/pure ]; then
  git -C ~/.zsh/pure pull
else
  git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
fi

plugins_dir=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
mkdir -p $plugins_dir

### Custom ZSH Plugins
echo Checking zsh plugins...
if [ -d "$plugins_dir/zsh-autosuggestions" ]; then
  git -C "$plugins_dir/zsh-autosuggestions" pull
else
  git clone https://github.com/zsh-users/zsh-autosuggestions $plugins_dir/zsh-autosuggestions
fi

if [ -d "$plugins_dir/zsh-completions" ]; then
  git -C "$plugins_dir/zsh-completions" pull
else
  git clone https://github.com/zsh-users/zsh-completions $plugins_dir/zsh-completions
fi

if [ -d "$plugins_dir/zsh-syntax-highlighting" ]; then
  git -C "$plugins_dir/zsh-syntax-highlighting" pull
else
  git clone https://github.com/zsh-users/zsh-syntax-highlighting $plugins_dir/zsh-syntax-highlighting
fi

### TMUX
echo Checking tmux plugins...
if [ -d "$HOME/.tmux/plugins" ]; then
  git -C "$HOME/.tmux/plugins/tpm" pull
else
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
