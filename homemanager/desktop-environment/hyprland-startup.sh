#!/usr/bin/env bash

swaybg --mode=fill --image=/run/current-system/sw/share/backgrounds/gnome/adwaita-d.jpg &

eww daemon
eww open notification-window
# eww open topbar-window
# eww open bottombar-window


# dunstify "sending notification w/ dunstify"

# add pkgs.networkmanagerapplet
# nm-applet --indicator &

# waybar &