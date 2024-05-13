#!/usr/bin/env bash

if [ -z $1 ]; then 
	echo "No package given!"
	exit 1
else
	echo $(dirname $(dirname $(readlink $(which $1))))
fi
