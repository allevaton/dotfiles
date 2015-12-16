

export PATH="/usr/bin:/usr/local/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"

if [ -d "$HOME/.local/bin" ]
then
    export PATH="$PATH:$HOME/.local/bin"
fi
export WORKSPACE="$HOME/workspace"
export WS="$WORKSPACE"

export EDITOR="vim"
export BROWSER="google-chrome-stable"

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

eval $(dircolors ~/.dircolors)

#eval $(ssh-agent)
