#!/usr/bin/env bash

headerlist='["Generation","Date","NixOS Version","Kernel Version"]'
attrlist="[.generation, .date, .nixosVersion, .kernelVersion]"

dateformat="[ .[] | .date=(.date|fromdate|strflocaltime(\"%d %B %Y - %I:%M %p\"))]"
currentstring="[ .[] | .generation = if .current then ( .generation| tostring ) + \" *\" else .generation end ]"

jqstring="$headerlist, (.[] | $attrlist) | @tsv"

generations_json="$(nixos-rebuild list-generations --json)"
generations_json=$(echo $generations_json | jq '.[] += {deletable: false}')

generations_table=$( echo "$generations_json"| jq -r "$dateformat" | jq -r "$currentstring" | jq -r "$jqstring" | column --table --separator $'\t' )

echo "$generations_table"
# echo "$generations_json"

# instead go through generations in reverse order
# set initial flag of "delete before"
# for each generation
#   if not current
#   if not one-previous
#   if date<cleandate
#       update delete_before to include this

noncurrent_json=$(echo "$generations_json" | jq -r "[ .[] | select(.current==false) ]")

# get just the dates as an array
read -ra datesarray <<< $(echo "$noncurrent_json" | jq -r ".[] | .date" | tr '\n' ' ')

# don't delete the previous generation (keep 1 backup)
deleteable_dates=("${datesarray[@]:1}")
# echo "${deleteable_dates[@]}"

days=7
deleteFromInt="$(date --date="$days days ago" "+%s")"

deletable_dates_json=$(jq -n '$ARGS.positional' --args "${deleteable_dates[@]}")
deletable_dates_json=$(echo "$deletable_dates_json" | jq "[ .[] | select(.>$deleteFromInt)]")

deletable_dates_json=$(echo "$deletable_dates_json" | jq -r "[.[] | .=(.|fromdate|strflocaltime(\"%d %B %Y - %I:%M %p\"))]")
echo "$deletable_dates_json"

# deleteable_dates=$(echo "${deleteable_dates[@]}" | jq -r --jsonargs "$dateformat")
# echo "${deleteable_dates[@]}"

# check which actual generations are deleteable
# deleteable_ids=$(echo "$noncurrent_json" | jq -r --arg deletedates $deletable_dates '.[] | select(.date in $deletedates)')
# echo $deletable_ids

testjson='[{"value":"1"}, {"value":"2"}, {"value":"3"}]'
selectlist=(2)
selected=$( echo "$testjson" | jq -r --arg list "${selectlist[@]}" '.[] | ( .value | inside($list) )')
echo "$selected"

# noncurrent_generations=$( echo "$generations_json" | jq "[ .[] | select(.current==false)]")
#
# if [[ "$(echo $noncurrent_generations | jq '. | length' )" == "1" ]]; then
#     echo "Only one non-current NixOS generation. Keeping for rollback."
# fi
#
# days=7
# deleteFromInt="$(date --date="$days days ago" "+%s")"
# deleteable_generations="$(echo $noncurrent_generations | jq "[ .[] | select(.date>$deleteFromInt)]")"
#
# echo "Deletable generations: "
# echo "$(echo $deleteable_generations | jq '.[] | .generation')"
#

# echo $deleteable_generations
