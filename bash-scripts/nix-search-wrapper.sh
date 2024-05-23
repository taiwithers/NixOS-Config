#!/usr/bin/env bash

if [ -z $1 ]; then 
	echo "Missing search term"
	exit 1
fi

system="x86_64-linux"
stable="23.11"
unstable="unstable"

stableResultsFile="/tmp/stableResults.json"
unstableResultsFile="/tmp/unstableResults.json"

# ANSI codes
OSC="\u001B]" # operating system command
BELL="\u0007"
LINK_BUFFER="8;;"
END_FMT="\e[0m"
link_style="\e[35m" # foreground magenta
stable_style="\e[32m" # foreground green
unstable_style="\e[34m" # foreground blue
programs_style=


getChannelSearchResults () {
	# echo "Searching channel $1 with args ${@:2}"
	local results="$(nix-search --channel=$1 --json ${@:2})"
	
	# remove newlines and add commas
	results=$(echo "$results" | sd "\n\{" ",{")

	# wrap with square brackets
	results="[$(echo $results)]"

	# extract information with jq
	results=$(echo $results | jq  "[.[] | select(.package_platforms | contains([\"$system\"])) | {
													name: .package_attr_name,
												 	versions: {\"$1\":.package_pversion},
												 	homepage: .package_homepage,
												 	programs: .package_programs
												}] ")

	echo "$results"
}
makeLink () { echo "${OSC}${LINK_BUFFER}${2}${BELL}${1}${OSC}${LINK_BUFFER}${BELL}"; }
removeQuotes() { echo $1 | sd '^"' '' | sd '"$' ''; }
getJSONValue () { echo $1 | jq ".[0].$2"; }

# save search results to file so they can be piped through jq again
echo $(getChannelSearchResults $stable $@) > $stableResultsFile
echo $(getChannelSearchResults $unstable $@) > $unstableResultsFile

# merge results from search
merged=$(jq '. + (input | .) | group_by(.name) | 
				foreach .[] as $i (0; 
					if ($i | length == 2) then 
						($i.[0]*$i.[1]) 
					else 
						$i.[0] 
					end)' $stableResultsFile $unstableResultsFile)

# echo $merged | jq
# # run through each result
(echo $merged | jq -c "[.]") | while read item; do		

	# extract information
	name=$(removeQuotes $(getJSONValue $item "name"))
	url=$(removeQuotes $(getJSONValue $item "homepage.[0]"))
	stableVersion=$(removeQuotes $(getJSONValue $item "versions.\"$stable\""))
	unstableVersion=$(removeQuotes $(getJSONValue $item "versions.\"$unstable\""))
	provides=$(echo $(getJSONValue $item "programs") | sd "\n" "" | sd -F "[ " "[" | sd -F " ]" "]" | sd '"' '')

	# add formatting/colours
	nameString="${link_style}$(makeLink $name $url)${END_FMT}"
	
	stableString=""
	if [ ! $stableVersion == "null" ]; then stableString="${stable}:${stable_style}${stableVersion}${END_FMT}"; fi
	
	unstableString=""
	if [ ! $unstableVersion == "null" ]; then unstableString="${unstable}:${unstable_style}${unstableVersion}${END_FMT}"; fi
	
	providesString=""
	if [ ${#provides} -gt 2 ]; then providesString="-> ${programs_style}${provides}${END_FMT}"; fi

	# print :)
	echo -e "$nameString $stableString $unstableString $providesString"
done
