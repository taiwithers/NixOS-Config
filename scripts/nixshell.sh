#!/usr/bin/env bash

# https://github.com/starship/starship/issues/6052#issuecomment-2275606204
# Initialize empty arrays for package names and options
ps=()
os=()
pnames=()

# Loop through all the arguments
for p in "$@"; do
    if [[ "$p" != --* ]]; then
        # If not an option, add it to the package names array
        ps+=("nixpkgs#$p")
        pnames+=("$p")
    else
        # If it is an option, add it to the options array
        os+=("$p")
    fi
done

# Construct the command
cmd="SHELL=\$SHELL IN_NIX_SHELL=\"impure\" NIX_SHELL_PKGS=\"${pnames[*]}\" nix shell ${os[*]} ${ps[*]}"
# echo "Executing \`$cmd\`..."

# Execute the command
# shellcheck disable=SC2086
eval $cmd
