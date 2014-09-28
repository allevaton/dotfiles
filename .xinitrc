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
# TODO: move all mosue settings from /etc/X11/xorg.conf.d/50-synaptics.conf to here
# I don't like them there.

# Keyboard rates should be faster
xset r rate 210 30

# Honestly, not liking the screen blanking
xset -dpms
xset s off

# Mouse specific setup
#
xset m 10/6 0
# Find the G9x
while read id
do
    xinput set-prop $id 'Device Accel Profile' 2
    xinput set-prop $id 'Device Accel Constant Deceleration' 2.85
    xinput set-ptr-feedback $id 0 18 10
done <<< "`xinput | awk '/G9x/{print $7}' | awk -F= '{print $2}'`"

# Don't like being blinded all the time
# Sometimes f.lux isn't enough, y'know?
# XXX: This may not work in some instances.
xbacklight -set 60

# We like Ctrl+Alt+Backspace, right?
setxkbmap -option terminate:ctrl_alt_bksp

# Load the general X configuration
xrdb $HOME/.Xresources

###########################################################
# Startup programs and start the WM
###########################################################

# Start f.lux for my eyes.
# But don't start it if it's already started
xflux -z 02038

gvfs-mime --set x-scheme-handler/http chromium.desktop &

# We like sound
start-pulseaudio-x11 &

# Lastly, start the DE/WM specified, or not specified
case "$1" in
    kde5)
        export KF5=/opt/kf5
        export QML2_IMPORT_PATH=$KF5/lib/qt/qml:/usr/lib/qt/qml
        export QT_PLUGIN_PATH=$KF5/lib/qt/plugins:/usr/lib/qt/plugins
        export XDG_CONFIG_DIRS=$KF5/etc/xdg:/etc/xdg
        export PATH=$KF5/bin:$PATH
        kwin_x11 --replace;;

    gnome)

        exec gnome-session;;

    # Default is i3
    *)
        # Looks like Skype actually works in i3
        # No harm in starting it.
        skype &

        # Start irc. Luckily, this is minimal
        hexchat --minimize=2 &

        # Wallpapers are sexy.
        nitrogen --restore &

        # Yes, steam.
        steam -silent &

        # Launch i3
        exec i3
        ;;
esac

# vim:ts=4
