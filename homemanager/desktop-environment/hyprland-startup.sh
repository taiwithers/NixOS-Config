#!/usr/bin/env bash

swaybg --mode=fill --image=/run/current-system/sw/share/backgrounds/gnome/fold-l.jxl &

eww kill
eww daemon
eww open topbar-window
eww open bottombar-window

# dunstify "sending notification w/ dunstify"

# add pkgs.networkmanagerapplet
# nm-applet --indicator &

# waybar &