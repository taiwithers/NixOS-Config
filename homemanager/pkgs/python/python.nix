{...}: let
  condainit = builtins.readFile ./conda-init.sh;
in {
  programs.bash.bashrcExtra = ''
    ${condainit}

    # clean up ~
    export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc
  '';
  #   programs.bash.initExtra = ''
  #     conda_active="$(conda 2>&1 /dev/null)"
  #     if [[ $? -eq 127 ]]; then
  #       conda-shell
  #       echo "activating conda"
  #     else
  #       echo "not activating conda"
  #     fi
  #   '';

  #   programs.bash.logoutExtra = ''
  #     echo "running conda deactivate"
  #     conda deactivate
  #   '';
}
# conda env update --file ~/.config/NixOS-Config/homemanager/pkgs/python/python-qstar.yml

