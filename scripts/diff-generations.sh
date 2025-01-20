#!/usr/bin/env bash

getNthHomeManagerProfile() {
  home-manager generations | sed --quiet "$1,$1p" | sd --max-replacements=1 ".* /" "/"
}


to_jq() {
  echo "$1" | jq -r "$2"
}

case "$1" in
home)
  currentHomeGeneration=$(getNthHomeManagerProfile 1)
  previousHomeGeneration=$(getNthHomeManagerProfile 2)
  nvd diff "$previousHomeGeneration" "$currentHomeGeneration"
  ;;
nixos)
  systemGenerationsJson="$(nixos-rebuild list-generations --json)"

  previousSystemGenerationID=$(to_jq "$systemGenerationsJson" "[.[] | select(.current | not) | .generation] | first")
  currentSystemGenerationID=$(to_jq "$systemGenerationsJson" ".[] | select(.current) | .generation")
  previousSystemGeneration="/nix/var/nix/profiles/system-$previousSystemGenerationID-link"
  currentSystemGeneration="/nix/var/nix/profiles/system-$currentSystemGenerationID-link"
  
  nvd diff "$previousSystemGeneration" "$currentSystemGeneration"
  ;;
esac

# use system.(user)activationScripts & home.activation instead of aliases
# https://github.com/luishfonseca/nixos-config/blob/main/modules/upgrade-diff.nix
