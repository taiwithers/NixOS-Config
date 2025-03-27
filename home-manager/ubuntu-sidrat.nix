{
  config,
  pkgs,
  colours,
  ...
}:
{
  imports =
    map
      (
        fname:
        import ./pkgs/${fname}.nix {
          inherit
            config
            pkgs
            colours
            ;
        }
      )
      [
        "bash"
        "bat"
        "bottom"
        "blesh"
        "cod"
        "common-git"
        "duf"
        "dust"
        "eza"
        "fzf"
        # "kitty" # use icat on remote
        # "latex"
        "lazygit"
        "neovim/neovim"
        "pdftools"
        # "python/python"
        "ripgrep"
        # "sublime-text/sublime-text"
        "starship"
        "tldr"
        "zoxide"
      ];
  home.packages = with pkgs; [
    fastfetch
    shfmt
    libqalculate
    nix-output-monitor
    xdg-ninja

    strace
    ds9
    cloc
  ];



  programs.git = {
    extraConfig = {
      credential.credentialStore = "gpg";
    };
    # signing.key = pkgs.lib.mkForce null;
    # signing.signByDefault = pkgs.lib.mkForce false;
  };

 home.sessionVariables = {
    AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials";
    AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config";
    AZURE_CONFIG_DIR="$XDG_DATA_HOME/azure";
    DOCKER_CONFIG="$XDG_CONFIG_HOME/docker";
    DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet";
    PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";
    IPYTHONDIR = "${config.xdg.configHome}/ipython";
    JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";

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

  # home.activation."astropyFoldersActivation" =
  #   with config.common;
  #   config.lib.dag.entryAfter [ "writeBoundary" ] ''
  #     if [[ ! -d "${configHome}/astropy" ]]; then
  #       mkdir "${configHome}/astropy"
  #     fi

  #     if [[ ! -d "${cacheHome}/astropy" ]]; then
  #       mkdir "${cacheHome}/astropy"
  #     fi
  #   '';

  # home.activation."linkBinariesForSudo" =
  #   let
  #     pkgname = pkgs.eza;
  #     binary = "eza";
  #   in
  #   config.lib.dag.entryAfter [ "writeBoundary" ] ''
  #     if [[ ! -e "/usr/bin/${binary}" ]]; then # file does not exist
  #       sudo ln -s ${pkgname}/bin/${binary} /usr/bin/${binary}
  #     fi
  #   '';

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 7d";
  };

  common.nixConfigDirectory = "${config.common.userHome}/Nix";
  common.useXDG = true;
  common.nixos = false;
  # home.shellAliases."storagespace" =
  # "dust --no-percent-bars --depth 0 --no-colors --skip-total --full-paths /1-Data-Fast /2-Data-Medium /3-Data-Slow /home/$USER /nix";
  home.stateVersion = "24.11";
}
