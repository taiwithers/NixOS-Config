#!/usr/bin/env bash

if [[ -z $1 ]]; then
	days="30"
	echo "Using default period $days days"
else
	days=$1
	echo "Using selected period $days days"
fi
deleteFrom="$(date --date="$days days ago" "+%Y-%m-%d %H:%M")"
echo "Deleting material prior to $deleteFrom"
echo 

echo "Emptying trash"
# trash empty --before $days"d"
echo 


generations="$(home-manager generations)\n$deleteFrom\n"
generations=$(sort <(echo -e "$generations") --reverse)
lines="$(wc -l <(echo -e "$generations") | sed 's/ .*$//g')"
generations="$(grep --fixed-strings --after-context $lines "$deleteFrom" <(echo -e "$generations"))"
generations="$(sed '1d' <(echo -e "$generations"))" # remove first line
# generations="$(sed 's/^.*id //g' <(echo -e "$generations"))" # remove front of line
# generations="$(sed 's/->.*$//g' <(echo -e "$generations"))" # remove back of line
# generations="$(echo "$generations" | tr '\n' ' ')" # remove newlines

if [[ "$(echo -e $generations | wc -l | sed 's/ .*$//g')" -gt 1 ]]; then 
	echo "Removing Home Manager generations"
	echo "$generations"
	read -n 1 -p "Confirm removal? y/[n] " confirmation
	echo
	if [[ $confirmation == "y" ]]; then 
		home-manager expire-generations "-$days days"
	fi
else
	echo "No Home Manager generations to delete"
fi
echo

echo "Removing nixos generations"
echo "To be deleted:"
nix-collect-garbage --delete-older-than "$days""d" --dry-run
read -n 1 -p "Confirm removal? y/[n] " confirmation
echo
if [[ $confirmation == "y" ]]; then 
	nix-collect-garbage --delete-older-than "$days""d"
fi
echo

read -n 1 -p "Clean nix store? y/[n] " confirmation
echo
if [[ $confirmation == "y" ]]; then 
	nix-store --gc
fi
echo

read -n 1 -p "Optimise nix store? y/[n] " confirmation
echo
if [[ $confirmation == "y" ]]; then 
	nix-store --optimise
fi
echo

read -n 1 -p "Clean conda? y/[n] " confirmation
echo
if [[ $confirmation == "y" ]]; then 
	(
		conda-shell -c "conda clean --all"
		
	)
fi
echo
