#!/bin/bash
#
# ~/.xinitrc
#
# This is executed when X launches (with startx).
#
## Initial X settings that we like

    # Mouse speed
    # These settings are now set in /etc/X11/xorg.conf.d/50-synaptics.conf
    # Please edit mouse-related settings there.
    # Keyboard rates should be faster
    xset r rate 210 30

    # Honestly, not liking the screen blanking
    xset -dpms
    xset s off

    # Don't like being blinded all the time
    # Sometimes f.lux isn't enough, y'know?
    xbacklight -set 60

    # We like Ctrl+Alt+Backspace, right?
    setxkbmap -option terminate:ctrl_alt_bksp


# This is kind of useful
export WORKSPACE="$HOME/workspace"
export WS="$WORKSPACE"
export EDITOR="vim"

# Load the general X configuration
xrdb $HOME/.Xresources

##
# Startup programs go here.

# Start f.lux for my eyes.
# But don't start it if it's already started
xflux -z 02038

# Lastly, start the DE/WM specified, or not specified
case "$1" in
    gnome)
        exec gnome-session;;

    # Default is i3
    *)
        # Looks like Skype actually works in i3
        # No harm in starting it.
        skype &

        # Start irc. Luckily, this is minimal
        #hexchat --minimize=2 &

        # Wallpapers are sexy.
        nitrogen --restore &

        # Launch i3
        exec i3
        ;;
esac

# vim:ts=4
