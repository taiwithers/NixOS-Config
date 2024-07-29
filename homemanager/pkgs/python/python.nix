{ config, pkgs, ... }:
{
  home.packages = [ pkgs.micromamba ];
  programs.bash.bashrcExtra = ''
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
  '';

  home.sessionVariables."PYTHONSTARTUP" = "${config.xdg.configHome}/python/pythonrc";

  home.shellAliases = {
    mamba = "micromamba";
    update-qstar = "micromamba env update --file ${config.xdg.configHome}/NixOS-Config/homemanager/pkgs/python/python-qstar.yml";
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
