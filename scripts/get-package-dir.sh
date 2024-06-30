#!/usr/bin/env bash

if [ -z $1 ]; then 
	echo "No package given!"
	exit 1
else
	linkedDirectory="$(which $1 2> /dev/null)"
	if [[ $? -eq 0 ]]; then
		echo $(dirname $(dirname $(readlink $linkedDirectory)))
		allLinkedDirectories="$(which --all $1 2> /dev/null)"
		echo $allLinkedDirectories
	else
		echo "Can't find package $1 in PATH"
	fi
fi