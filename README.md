## Pushing

```sh
$ git push
$ git push github HEAD
```

## Additional scripts for first-time setups

### zplug, plugins for zsh
```
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
```

Once installed, open a new terminal and run `zplug install`

### vim-plugged for neovim
```
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

Open a new neovim instance and run `:PlugInstall`
