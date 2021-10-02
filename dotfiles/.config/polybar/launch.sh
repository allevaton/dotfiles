#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1
echo "-- RESTART --" | tee -a /tmp/polybar_top.log /tmp/polybar_bottom.log
polybar -r top >> /tmp/polybar_top.log 2>&1 &
#polybar main >> /tmp/polybar_main.log 2>&1 &

echo "Bar launched..."

