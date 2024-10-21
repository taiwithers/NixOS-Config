#!/usr/bin/env bash

headerlist='["Generation","Date","NixOS Version","Kernel Version"]'
attrlist="[.generation, .date, .nixosVersion, .kernelVersion]"

dateformat="[ .[] | .date=(.date|fromdate|strflocaltime(\"%d %B %Y - %I:%M %p\"))]"
currentstring="[ .[] | .generation = if .current then ( .generation| tostring ) + \" *\" else .generation end ]"

jqstring="$headerlist, (.[] | $attrlist) | @tsv"

generations_json="$(nixos-rebuild list-generations --json)"
generations_json=$(echo "$generations_json" | jq '.[] += {deletable: false}')

generations_table=$( echo "$generations_json"| jq -r "$dateformat" | jq -r "$currentstring" | jq -r "$jqstring" | column --table --separator $'\t' )

echo "$generations_table"
