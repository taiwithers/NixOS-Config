#!/usr/bin/env bash

getNthHomeManagerProfile() {
	home-manager generations | sed --quiet "$1,$1p" | sd --max-replacements=1 ".* /" "/"
}

currentGeneration=$(getNthHomeManagerProfile 1)
previousGeneration=$(getNthHomeManagerProfile 2)

nvd diff "$previousGeneration" "$currentGeneration"

# nvd diff /nix/var/nix/profiles/system-{14,15}-link