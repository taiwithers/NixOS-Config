#!/usr/bin/env bash
# remove duplicate $PATH entries
# https://stackoverflow.com/a/75111897

function clean_path() {
  declare -A SPATH
  local RET_VAL
  local A
  local OIFS=$IFS

  IFS=':'
  for A in ${PATH}; do
    [ -z "${SPATH[${A}]}" ] || continue

    SPATH[${A}]=${#SPATH[*]}

    if [ -z "$RET_VAL" ]; then
      RET_VAL="$A"
    else
      RET_VAL="${RET_VAL}:${A}"
    fi
  done

  IFS=$OIFS
  PATH=$RET_VAL
  export PATH
}
