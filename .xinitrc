#!/bin/bash
#
# ~/.xinitrc
#
# This is executed when X launches (with startx).
#
## Initial X settings that we like

    # Mouse speed
    #synclient AccelFactor=0.06
    #synclient MinSpeed=0.5
    xset m 20 5

    # Never really liked touchpad tap
    #synclient TapButton1=0

    # Makes more sense for 2 finger tap to be right click
    #synclient TapButton3=2
    #synclient TapButton2=3

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
