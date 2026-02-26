# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is a personal dotfiles repository managed with rsync. The actual config files live under `dotfiles/` mirroring the `$HOME` directory layout. Three scripts manage syncing:

- `sync-from-local` — copies tracked files from `$HOME` into `dotfiles/` (use before committing)
- `overwrite-local` — applies `dotfiles/` onto `$HOME` (backs up first to `_local-backup/`)
- `diff` — shows a colored diff between `dotfiles/` and `$HOME`
- `filter.txt` — rsync filter rules controlling which files are tracked

## Tracked Configs

| File/Dir | Purpose |
|---|---|
| `.zshrc` | Zsh shell: oh-my-zsh + zplug plugins, aliases, starship prompt |
| `.tmux.conf` | Tmux: catppuccin theme, TPM plugins, vim-tmux-navigator integration |
| `.vimrc` | Legacy Vim config |
| `.profile` | Login shell env |
| `.config/nvim/` | Neovim Lua config (see its own `CLAUDE.md` for details) |
| `.config/lazygit/config.yml` | Lazygit settings |
| `.config/alacritty/alacritty.yml` | Alacritty terminal config |
| `.config/fish/` | Fish shell: fisher plugins, starship prompt, aliases mirroring zsh |

## Workflow

To pull live changes from `$HOME` into the repo before committing:
```sh
./sync-from-local
```

To apply the repo's dotfiles onto the local machine (backs up existing files to `_local-backup/`):
```sh
./overwrite-local
```

To preview differences between repo and live system:
```sh
./diff
```

## Adding New Files to Track

Edit `filter.txt` and add an include rule before the final `- /**` exclude:
```
+ /.config/newapp
+ /.config/newapp/**
```

## Key Tool Versions / Plugins

- **Zsh**: oh-my-zsh + zplug; plugins include git, z, fzf, nvm, uv, virtualenv
- **Prompt**: starship
- **Tmux**: TPM; plugins include catppuccin/tmux (macchiato flavor), tmux-resurrect, tmux-thumbs, vim-tmux-navigator
- **Neovim**: lazy.nvim plugin manager; see `dotfiles/.config/nvim/CLAUDE.md` for full nvim architecture
