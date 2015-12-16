#!/usr/bin/env bash
#
# ~/.xinitrc
#
# This is executed when X launches (with startx).
#

###########################################################
# Initial X settings that we like
###########################################################

# Keyboard rates should be faster
xset r rate 210 30

# Honestly, not liking the screen blanking
xset -dpms
xset s off

# Mouse specific setup
#
xset m 10/6 0

# high threshold for not accidentally hitting it
synclient HorizScrollDelta=200
synclient HorizTwoFingerScroll=1
synclient TapButton2=3
synclient TapButton3=2
synclient TapButton1=0

# Find my mouse to adjust speed and accel settings
device=G9x
for id in $(xinput | grep -oP "($device).*id=\K([0-9]*)")
do
  xinput set-prop $id 'Device Accel Profile' 2
  xinput set-prop $id 'Device Accel Constant Deceleration' 2.85
  xinput set-ptr-feedback $id 0 18 10
done

# Don't like being blinded all the time
# Sometimes f.lux isn't enough, y'know?
# XXX: This may not work in some instances.
xbacklight -set 60 &

# We like Ctrl+Alt+Backspace, right?
setxkbmap -option terminate:ctrl_alt_bksp &

# Load the general X configuration
xrdb $HOME/.Xresources &

###########################################################
# Startup programs and start the WM
###########################################################

# Start f.lux for my eyes unconditionally (auto-forks)
xflux -z 02038

# TODO why is this here...
gvfs-mime --set x-scheme-handler/http google-chrome.desktop &

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

  bspwm)
    sxhkd &
    exec bspwm;;

  # i3
  *)
    # notification daemon
    (dunst || i3-nagbar -m 'dunst (notification daemon) not found') &

    skype &
    #hexchat --minimize=2 &
    steam -silent &

    # This fixes some problems with odd sound drivers
    start-pulseaudio-x11 &

    # wallpapers
    (nitrogen --restore || notify-send -u critical 'nitrogen not found, wallpapers will not load') &

    # Launch i3
    exec i3 --shmlog-size=26214400 > /tmp/i3log-$(date +'%F-%k-%M-%S') 2>&1;;
esac

# vim:ts=2
