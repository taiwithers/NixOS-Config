#!/usr/bin/env bash

swaybg --mode=fill --image=/run/current-system/sw/share/backgrounds/gnome/blobs-l.svg &

eww kill
eww daemon
eww open topbar-window
eww open fullwidth-window
# eww open bottombar-window

# dunstify "sending notification w/ dunstify"

# add pkgs.networkmanagerapplet
# nm-applet --indicator &

# waybar &