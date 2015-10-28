export PATH="/usr/bin:/usr/local/bin"

# As much as I don't like perl, they're fancy enough to have their own bin
# folders... of course. *sigh*
export PATH="$PATH:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"

if [ -d "$HOME/.local/bin" ]
then
    export PATH="$PATH:$HOME/.local/bin"
fi
export WORKSPACE="$HOME/workspace"
export WS="$WORKSPACE"

export EDITOR="vim"
export BROWSER="chromium"

eval $(dircolors ~/.dircolors)

#eval $(ssh-agent)
