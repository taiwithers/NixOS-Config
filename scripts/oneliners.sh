#!/usr/bin/env bash

# Aliases


alias untar='tar -xvf'
alias printenv='printenv | sort'
alias brc='source ~/.bashrc'
alias bbrc='bat ~/.bashrc' # requires: bat
alias sudo='sudo --reset-timestamp '

# Functions


## create a directory and cd into it
mkc() {
	mkdir --parents "$1"
	cd "$1"
}


## backup functions
bk() {
  cp "$1"{,.backup}
}

trashbk() { # requires: trash-cli
  trash-put "$1.backup"
}

diffbk() { # requires: delta
  delta "$1"{.backup,}
}


## `which` that follows symlinks
owhichl() { # requires: eza
	RESULT=$(which -a "$@")
	if [[ -z "$RESULT" ]]; then
	    echo "No results for " "$@"
	    return 1
	fi

	# shellcheck disable=SC2086
	eza --long --all --no-user --time-style=iso ${RESULT}
}


## search in dir and open folder at text
open-at-line() {
	rg --line-number . | fzf \
												   --delimiter=':' \
												   --preview='bat --color=always {1}' \
												   --preview-window '+{2}+3/3,~3' \
												   --bind 'enter:become(nvim {1} +{2})'
}