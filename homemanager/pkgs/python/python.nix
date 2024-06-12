{...}: let
  conda-init = ''
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    # ...and home-manager and myself
    __conda_setup="$('/home/tai/.conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
    	eval "$__conda_setup"
    else
    	if [ -f "home/tai/.conda/etc/profile.d/conda.sh" ]; then
    		. "/home/tai/.conda/etc/profile.d/conda.sh"
    	else
    		export PATH="/home/tai/.conda/bin:$PATH"
    	fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
  '';
in {
  programs.bash.bashrcExtra = ''
    ${conda-init}
    export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc
  '';
  programs.bash.initExtra = ''
    conda_active="$(conda)"
    if [[ $? -eq 127 ]]; then
      conda-shell
      echo "activating conda"
    else
      echo "not activating conda"
    fi
    # conda-shell # activate conda in the base environment
  '';

  programs.bash.logoutExtra = ''
    conda deactivate
    exit
  '';
}
