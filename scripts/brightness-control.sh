#!/usr/bin/env bash

# requirements: bash, brightnessctl, awk, notify-send

set -euo pipefail

get_brightness() {
  brightnessctl --machine-readable | awk 'BEGIN{FS=","} {print $4}' | awk 'BEGIN{FS="%"} {print $1}'
}

function usage() {
  echo "Brightness is $(get_brightness)%"
  echo "Usage: brightness-control up|down|min|max"
}

minimum_percentage=5
change_percentage=5 # used for up/down

# check for early exit
case $1 in
up | max)
  if [[ $(get_brightness) -eq 100 ]]; then
    notify-send "Brightness already at maximum"
    exit 0
  fi
  ;;
down | min)
  if [[ $(get_brightness) -le $minimum_percentage ]]; then
    notify-send "Brightness already at minimum"
    exit 0
  fi
  ;;
esac

case $1 in
"up")
  action="+$change_percentage%"
  ;;
"down")
  action="$change_percentage%-"
  ;;
"min")
  action="$minimum_percentage%"
  ;;
"max")
  action="100%"
  ;;
*)
  usage
  exit 0
  ;;
esac

brightnessctl --class=backlight set $action
notify-send "Set brightness to $(get_brightness)"
