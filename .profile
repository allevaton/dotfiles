export PATH="$PATH:/usr/local/bin"

if [ -d "$HOME/.local/bin" ]
then
    export PATH="$PATH:$HOME/.local/bin"
fi

export WORKSPACE="$HOME/workspace"
export WS="$WORKSPACE"

export EDITOR="vim"
export BROWSER="chromium"

eval $(dircolors ~/.dircolors)
