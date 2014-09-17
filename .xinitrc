#!/bin/bash
#
# ~/.xinitrc
#
# This is executed when X launches (with startx).
#

###########################################################
# Initial X settings that we like
###########################################################

# Mouse speed
# XXX: These settings are now set in /etc/X11/xorg.conf.d/50-synaptics.conf
# Please edit mouse-related settings there.

# Keyboard rates should be faster
xset r rate 210 30

# Honestly, not liking the screen blanking
xset -dpms
xset s off

# Mouse specific setup
# Find the G9x
id=`xinput | awk '/G9x/{print $7}' | awk -F= '{print $2}' | tail -n 1`
xinput set-prop $id 'Device Accel Profile' 2
xinput set-prop $id 'Device Accel Constant Deceleration' 3
xset m 10/6 0

# Don't like being blinded all the time
# Sometimes f.lux isn't enough, y'know?
# XXX: This may not work in some instances.
xbacklight -set 60

# We like Ctrl+Alt+Backspace, right?
setxkbmap -option terminate:ctrl_alt_bksp

# Load the general X configuration
xrdb $HOME/.Xresources

###########################################################
# Global environmental variables
###########################################################

# This is kind of useful
export WORKSPACE="$HOME/workspace"
export WS="$WORKSPACE"
export EDITOR="vim"

###########################################################
# Startup programs and start the WM
###########################################################

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
