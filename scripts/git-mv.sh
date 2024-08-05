#!/usr/bin/env bash
source=$1
destination=$2

inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

if [ "$inside_git_repo" ]; then
  git mv "$source" "$destination"
else
  mv "$source" "$destination"
fi