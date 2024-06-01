#!/usr/bin/env bash

# note that nixos-rebuild test and boot are not available


# internal variables
builder=""		# [nix|hm]
action="switch" # [switch|build|list|rollback]
buildPath=""	# 
listLength=15	# 
rollbackGeneration=
useFlake=true
configFile="~/.config/rebuild.conf"
impure=false
showTrace=true

showHelp () {}

readConfig () {
	if ! [ -f $configFile ]; then return 0; fi
	. $configFile
	# https://askubuntu.com/a/743641
}

processOptions () {
	while [ "$#" -gt 0 ]; do # while there exist unprocessed arguments
		entry="$1"
		shift 1

		case "$entry" in 
			help) showHelp;;
			nix|hm) builder=$entry ;;
			switch|build|list|rollback)
				action=$entry
				if [[ "$entry" = list && ! ( -z $1 ) ]]; then
					listLength=$1
					shift 1
				fi
				if [ "$entry" = rollback ]; then
					if [ -z $1 ]; then
						echo "rollback requires an argument"
						exit 1
					fi
					rollbackGeneration=$1
					shift 1
				fi
				;;
			--flake) useFlake=true;;
			--no-flake) useFlake=false;;
			--impure) impure=true;;
			--no-impure) impure=false;;
			--path)
				if [ -z $1 ]; then
					echo "--path requires argument"
					exit 1
				fi
				buildPath=$1
				shift 1
				;;
			*)
				echo "Unknown option: $entry"
				exit 1
				;;
		esac
	done
}

runSwitch () {
	local command=()
	local options=()

	case $builder in
		nix) command+=("nixos-rebuild");;
		hm) command+=("home-manager");;
		*) echo "Unrecognized builder. Options are: nix hm" ;;
	esac

	case $action in
		switch|build) command+=("$action");;
		list)
			case $builder in
				nix) command+=("list-generations");;
				hm) command+=("generations");;
			esac
			;;
		rollback)
			;;
		*) echo "Unrecognized action. Options are: switch build list rollback" ;;
	esac

	# flake and buildpath
	if [ $useFlake ]; then
		options+=("--flake $buildPath")
	else
		case $builder in
			nix) options+=("-I nixos-config=$buildPath");;
			hm) options+=("-f $buildPath");;
		esac
	fi

	if [ $showTrace ]; then
		options+=("--show-trace")
	fi

	if [ $impure ]; then
		options+=("--impure")
	fi


}


readConfig
processOptions
