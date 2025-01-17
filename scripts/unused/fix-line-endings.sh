#!/usr/bin/env bash
fd --type f . "$1" --exec dos2unix {} \;
