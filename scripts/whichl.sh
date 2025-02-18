#!/usr/bin/env bash

# https://stackoverflow.com/a/51562375
RESULT=$(which -a "$@")
if [[ -z "$RESULT" ]]; then
    echo "No results for " "$@"
    return 1
fi

# shellcheck disable=SC2086
eza --long --all --no-user --time-style=iso ${RESULT}