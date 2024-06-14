# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# ...and home-manager and myself
__conda_setup="$('/home/tai/.conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
condabin="/home/tai/.conda/bin"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "home/tai/.conda/etc/profile.d/conda.sh" ]; then
		. "/home/tai/.conda/etc/profile.d/conda.sh"
	else
	    if ! [[ $PATH =~ "$condabin" ]]; then 
			export PATH="$PATH:$condabin"
		fi
	fi
fi
unset __conda_setup
unset condabin
# <<< conda initialize <<<