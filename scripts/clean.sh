#!/usr/bin/env bash

set +o nounset # don't error out if you encounter an unset parameter 

if [[ -z "$1" ]]; then
	days="30"
	echo "Using default period $days days"
else
	days=$1
	echo "Using selected period $days days"
fi
deleteFrom="$(date --date="$days days ago" "+%Y-%m-%d %H:%M")"
echo "Deleting material prior to $deleteFrom"
echo 

if [[ -n "$(trash list --before "$days""d")" ]]; then 
	echo "Emptying trash"
	trash empty --before "$days""d"
else
	echo "No trash to delete"
fi
echo 

generations="$(home-manager generations)\n$deleteFrom\n"
generations=$(sort <(echo -e "$generations") --reverse)
lines="$(wc -l <(echo -e "$generations") | sed 's/ .*$//g')"
generations="$(grep --fixed-strings --after-context "$lines" "$deleteFrom" <(echo -e "$generations"))"
generations="$(sed '1d' <(echo -e "$generations"))" # remove first line
# generations="$(sed 's/^.*id //g' <(echo -e "$generations"))" # remove front of line
# generations="$(sed 's/->.*$//g' <(echo -e "$generations"))" # remove back of line
# generations="$(echo "$generations" | tr '\n' ' ')" # remove newlines

if [[ -n "$generations" ]]; then 
	echo "Removing Home Manager generations"
	echo "$generations"
	read -r -n 1 -p "Confirm removal? y/[n] " confirmation
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
read -r -n 1 -p "Confirm removal? y/[n] " confirmation
echo
if [[ $confirmation == "y" ]]; then 
	nix-collect-garbage --delete-older-than "$days""d"
fi
echo

read -r -n 1 -p "Clean nix store? y/[n] " confirmation
echo
if [[ $confirmation == "y" ]]; then 
	nix-store --gc
fi
echo

read -r -n 1 -p "Optimise nix store? y/[n] " confirmation
echo
if [[ $confirmation == "y" ]]; then 
	nix-store --optimise
fi
echo

pycommands=(conda mamba micromamba)
for pycommand in "${pycommands[@]}"; do
	if [[ -n "$(builtin type -P "$pycommand")" ]]; then
		read -r -n 1 -p "Clean $pycommand? y/[n] " confirmation
		echo
		if [[ $confirmation == "y" ]]; then 
			$pycommand clean --all
		fi
	fi
done

echo
