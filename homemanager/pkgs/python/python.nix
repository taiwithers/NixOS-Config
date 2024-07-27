{pkgs, ... }:
{
  home.packages = [ pkgs.conda ];
  programs.bash.bashrcExtra =
    let
      conda-path = "/home/tai/.conda";
      conda-bin = "${conda-path}/bin";
      conda-profile = "${conda-path}/etc/profile.d/conda.sh";
    in
    # bash
    ''
      # >>> conda initialize >>>
      # !! Contents within this block are managed by 'conda init' !!
      # ...and home-manager and myself
      __conda_setup="$("${conda-bin}/conda" 'shell.bash' 'hook' 2> /dev/null)"
      if [ $? -eq 0 ]; then
        eval "$__conda_setup"
      else
        if [ -f "${conda-profile}" ]; then
          . "${conda-profile}"
        else
            if ! [[ $PATH =~ "${conda-bin}" ]]; then
            export PATH="$PATH:${conda-bin}"
          fi
        fi
      fi
      unset __conda_setup
      # <<< conda initialize <<<

      # clean up ~
      export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc
    '';

  # home.bashAliases = {
  #   update-qstar = "condaormamaba env update --file <path>";
  # };
}
# conda env update --file ~/.config/NixOS-Config/homemanager/pkgs/python/python-qstar.yml
