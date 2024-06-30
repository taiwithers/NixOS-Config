#!/usr/bin/env bash

getBinaryDirectory() {
		echo $(dirname $(dirname $(readlink $1)))
}

if [ -z $1 ]; then 
	echo "No package given!"
	exit 1
fi

# get all potentials (or try to)
allLinkedDirectories="$(which --all $1 2> /dev/null)"
if [[ $? -eq 1 ]]; then
	echo "Can't find package $1 in PATH"
	exit 1
fi

# if there's only one option returned by which
if [[ $allLinkedDirectories =~ "\n" ]]; then
	echo "$(getBinaryDirectory $allLinkedDirectories)"
	exit 0
fi

# get only unique options
allLinkedDirectories="$(echo -e $allLinkedDirectories | tr ' ' '\n' | sort --unique)"

# run the getBinaryDirectory function
allSourceDirectories=()
for link in $allLinkedDirectories; do
	allSourceDirectories+="$( getBinaryDirectory $link )\n"
done
allSourceDirectories="$(echo -e $allSourceDirectories | sort --unique)"
allSourceDirectories=($allSourceDirectories)

# write output
for i in ${allSourceDirectories[*]}; do
	echo $i
done
exit 0