#!/usr/bin/env bash
# modified from https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5

# A rebuild script that commits on a successful build
# useage: 
#     bash rebuild.sh nix
#     or
#     bash rebuild.sh home

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

# check for untracked .nix files, exit code 0 if any exist, exist code 1 if none do
{ 
  git status --short --untracked-files=normal "*.nix" | rg "\?\?" 
} > /dev/null

if [ $? -eq 0 ]; then
  echo "WARNING: The following untracked .nix files exist in "$directory 
  git status --short --untracked-files=normal "*.nix" | rg "\?\?"
  echo "Changes to these files will not be detected."
fi

set -e # needed to move this down because of the git status section

# Early return if no changes were detected (thanks @singiamtel!)
if git diff --quiet '*.nix'; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# Autoformat your nix files
alejandra . &>/dev/null \
  || ( alejandra . ; echo "Formatting failed!" && exit 1)

# Shows your changes
git diff -U0 '*.nix'

# call nixos-rebuild or home-manager as appropriate
echo "Building..."
build 

# Commit all changes with the generation metadata
git commit -am "$current"

echo "Rebuilt OK!" 

# Back to where you were
popd