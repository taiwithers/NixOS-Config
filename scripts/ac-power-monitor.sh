#!/usr/bin/env bash

# Requirements: acpi, notify-send, jq

set -euo pipefail

# 0: discharging
# 1: charging
function get_status() {
  if [[ $(acpi --ac-adapter) =~ "on-line" ]]; then
    echo 1
  else
    echo 0
  fi
}

function get_single_charge() {
  order=$1
  info_line=$(acpi --battery | sed -n "${order}p") # use sed to get the Xth line of `acpi --battery`
  # first sed removes "Battery [num]: [state] "
  # second expression removes the "%, [other info]"
  charge=$(echo "$info_line" | sed --regexp-extended --expression "s/Battery [0-9]: (\w|\s)+, //" --expression "s/%.*$//")
  echo "$charge"
}

function get_total_charge() {
  bat0=$(get_single_charge 1)
  bat1=$(get_single_charge 2)
  avg=$(echo "$bat0" "$bat1" | jq --slurp ".|(add/length)")
  echo "$avg"
}

function notify_if_changed() {
  previous_status=$1
  current_status=$(get_status)
  current_charge=$(get_total_charge)
  if [[ $current_status -gt $previous_status ]]; then
    notify-send "Charger connected, current charge: $current_charge%"
  elif [[ $current_status -lt $previous_status ]]; then
    notify-send "Charger disconnected, current charge: $current_charge%"
  fi
  echo "$current_status"
}

previous=0
while true; do
  previous=$(notify_if_changed "$previous")
  sleep 1
done
