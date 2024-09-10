#!/usr/bin/env bash

headerlist='["Generation","Date","NixOS Version","Kernel Version"]'
attrlist="[.generation, .date, .nixosVersion, .kernelVersion]"

dateformat="[ .[] | .date=(.date|fromdate|strflocaltime(\"%d %B %Y - %I:%M %p\"))]"
currentstring="[ .[] | .generation = if .current then ( .generation| tostring ) + \" *\" else .generation end ]"

jqstring="$headerlist, (.[] | $attrlist) | @tsv"

generations_json="$(nixos-rebuild list-generations --json)"

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

noncurrent_generations=$( echo "$generations_json" | jq "[ .[] | select(.current==false)]")

if [[ "$(echo $noncurrent_generations | jq '. | length' )" == "1" ]]; then
    echo "Only one non-current NixOS generation. Keeping for rollback."
fi

days=7
deleteFromInt="$(date --date="$days days ago" "+%s")"
deleteable_generations="$(echo $noncurrent_generations | jq "[ .[] | select(.date>$deleteFromInt)]")"

echo "Deletable generations: "
echo "$(echo $deleteable_generations | jq '.[] | .generation')"


# echo $deleteable_generations
