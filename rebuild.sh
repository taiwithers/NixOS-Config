#!/usr/bin/env bash
# modified from https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5

# A rebuild script that commits on a successful build
# useage: 
#     bash rebuild.sh nix
#     or
#     bash rebuild.sh home

set -e

# where do you keep your *.nix files?
directory_nixconfig=~/.config/nixfiles/system # should contain hardware-configuration.nix
filename_nixconfig=configuration.nix  # should be in above folder

directory_hmconfig=~/.config/nixfiles/homemanager
filename_hmconfig=home.nix # should be in above folder

logfile=nixos-switch.log # logfile will be in the above directories


case $1 in 
  'nix')
    directory=$directory_nixconfig
    build() {
      sudo nixos-rebuild switch -I nixos-config=$filename_nixconfig &>$logfile || (bat $logfile | rg error && exit 1)
      current=$(nixos-rebuild list-generations | rg current)
    }
  ;;

  'home')
    directory=$directory_hmconfig
    build() {
      home-manager -f $filename_hmconfig switch &>$logfile || (bat $logfile | rg error && exit 1)
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
# ^HEAD ensures that new files are detected as a change
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

echo "Rebuilt OK!" 