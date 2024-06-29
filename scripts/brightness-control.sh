#!/usr/bin/env bash

get_brightness () {
	echo "$(brightnessctl --machine-readable | awk 'BEGIN{FS=","} {print $4}' | awk 'BEGIN{FS="%"} {print $1}')"
}

current_percentage=$(get_brightness)

if [[ -n $2 ]] && [[ $2 -gt 0 ]]; then 
	percentage=$2
else
	percentage=10
fi

increase="+$percentage%"
decrease="$percentage%-"
minimum="$percentage%"
maximum="100%"

case $1 in 
	"inc")
		brightnessctl --quiet set $increase
		;;
	"dec")
		if [[ $(($current_percentage-$percentage)) -gt 0 ]]; then 
			brightnessctl --quiet set $decrease
		fi
		;;
	"min")
		brightnessctl --quiet set $minimum
		;;
	"max")
		brightnessctl --quiet set $maximum
		;;
esac

echo "Brightness is $(get_brightness)%"