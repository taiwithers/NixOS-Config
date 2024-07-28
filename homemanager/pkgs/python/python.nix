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
}
# conda env update --file ~/.config/NixOS-Config/homemanager/pkgs/python/python-qstar.yml
