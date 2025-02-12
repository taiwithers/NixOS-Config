#!/usr/bin/env bash
# shellcheck disable=all
set -x

confirm() {
  promptString="Continue? y/[n]"
  read -r -N 1 -p "${promptString} " input
  # if [[ ]]
  # echo # print new line
  # echo "$input"
  return $(test "$input" = "y")
}
