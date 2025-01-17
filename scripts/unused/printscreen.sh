#!/usr/bin/env bash

grim -g "$(slurp)" - | wl-copy

# generate notification that on click executes:
# wl-paste | swappy -f -
