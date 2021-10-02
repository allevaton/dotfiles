#!/bin/sh

player_status=$(playerctl status 2> /dev/null)
artist=$(playerctl metadata artist)
title=$(playerctl metadata title)

if [ "$player_status" = "Playing" ]; then
    echo "> $artist - $title"
elif [ "$player_status" = "Paused" ]; then
    echo "|| $artist - $title"
elif [ ! -z "$artist" ]; then
    echo "|| $artist - $title"
fi

