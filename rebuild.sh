#!/usr/bin/env bash
# modified from https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5

# A rebuild script that commits on a successful build
set -e

action=$1

# Edit your config
# $EDITOR configuration.nix

# cd to your config dir
pushd ~/.config/nixfiles

# Early return if no changes were detected (thanks @singiamtel!)
if git diff --quiet '*.nix'; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# Autoformat your nix files
alejandra . &>/dev/null \
  || ( alejandra . ; echo "formatting failed!" && exit 1)

# Shows your changes
git diff -U0 '*.nix'

case $action in 
  'nix')
    # Using nixos-rebuild:
    echo "NixOS Rebuilding..."

    # Rebuild, output simplified errors, log tracebacks
    sudo nixos-rebuild switch -I nixos-config=configuration.nix &>nixos-switch.log || (bat nixos-switch.log | rg --color error && exit 1)

    # Get current generation metadata
    current=$(nixos-rebuild list-generations | rg current)
  ;;

  'home')
    # Using home-manager
    echo "Home Manager Rebuilding..."

    # Rebuild, output simplified errors, log tracebacks
    home-manager -f home.nix switch &>nixos-switch.log || (bat nixos-switch.log | rg --color error && exit 1)

    # Get current generation metadata
    current=$(home-manager generations | sed -n 1p)
  ;;

  *)
    echo "Usage: bash rebuild.sh [nix|home]"
  ;;
esac

# Commit all changes with the generation metadata
git commit -am "$current"

# Back to where you were
popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available