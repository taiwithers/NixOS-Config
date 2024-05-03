#!/usr/bin/env bash
# modified from https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5

# A rebuild script that commits on a successful build
set -e

case $1 in 
  'nix')
    directory=~/.config/nixfiles/system
    build() {
      sudo nixos-rebuild switch -I nixos-config=configuration.nix &>nixos-switch.log || (bat nixos-switch.log | rg error && exit 1)
      current=$(nixos-rebuild list-generations | rg current)
    }
  ;;

  'home')
    directory=~/.config/nixfiles/homemanager
    build() {
      home-manager -f home.nix switch &>nixos-switch.log || (bat nixos-switch.log | rg error && exit 1)
      current=$(home-manager generations | sed -n 1p)
    }
  ;;

  *)
    echo "Usage: bash rebuild.sh [nix|home]" && exit 1
  ;;

esac


# cd to your config dir
pushd $directory

# Early return if no changes were detected (thanks @singiamtel!)
if git diff --quiet ^HEAD '*.nix'; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# Autoformat your nix files
alejandra . &>/dev/null \
  || ( alejandra . ; echo "Formatting failed!" && exit 1)

# Shows your changes
git diff -U0 '*.nix'

build 

# Commit all changes with the generation metadata
git commit -am "$current"

# Back to where you were
popd

echo "NixOS Rebuilt OK!" 