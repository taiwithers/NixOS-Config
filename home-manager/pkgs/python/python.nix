{
  config,
  pkgs,
  ...
}: let
  pyConfigDir = "${config.common.nixConfigDirectory}/home-manager/pkgs/python";
in {
  home.packages = [pkgs.micromamba];
  programs.bash.bashrcExtra =
    if !config.common.nixos
    then ''
      # >>> mamba initialize >>>
      # !! Contents within this block are managed by 'mamba init' !!
      export MAMBA_EXE='${pkgs.micromamba}/bin/micromamba';
      export MAMBA_ROOT_PREFIX='${config.xdg.stateHome}/micromamba';
      __mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
      if [ $? -eq 0 ]; then
        eval "$__mamba_setup"
      else
        alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
      fi
      unset __mamba_setup
      # <<< mamba initialize <<<
    ''
    else let
      flake-path = "${pyConfigDir}/shells/";
    in ''
      pyactivate() {
          if [[ -n $1 ]]; then
            nix develop --impure ${flake-path}#"$1"
          else
            nix develop --impure ${flake-path}
          fi
      }
    '';

  home.sessionVariables = {
    PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";
    IPYTHONDIR = "${config.xdg.configHome}/ipython";
    JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";
  };

  xdg.configFile."${pyConfigDir}/shells/shellrc.sh" = {
    text = ''
      updateenv() {
        micromamba update --file ${pyConfigDir}/shells/"$CONDA_DEFAULT_ENV".yml
      }
    '';
    executable = true;
  };

  xdg.configFile."${config.xdg.configHome}/python/pythonrc".text = ''
    def is_vanilla() -> bool:
        import sys
        return not hasattr(__builtins__, '__IPYTHON__') and 'bpython' not in sys.argv[0]


    def setup_history():
        import os
        import atexit
        import readline
        from pathlib import Path

        if state_home := os.environ.get('XDG_STATE_HOME'):
            state_home = Path(state_home)
        else:
            state_home = Path.home() / '.local' / 'state'

        history: Path = state_home / 'python_history'

        if not os.path.exists(str(history)):
          f = open(str(history), mode='a')
          f.close()

        readline.read_history_file(str(history))
        atexit.register(readline.write_history_file, str(history))


    if is_vanilla():
        setup_history()
  '';
}
# conda env update --file ~/.config/NixOS-Config/homemanager/pkgs/python/python-qstar.yml

