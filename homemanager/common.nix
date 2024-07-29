{
  config,
  pkgs,
  user,
  pkgs-config,
  ...
}:
let
  homeDirectory = "/home/${user}";
in
{
  home.sessionVariables = with config.xdg; {
    XDG_CONFIG_HOME = "${configHome}";
    XDG_STATE_HOME = "${stateHome}";
    XDG_DATA_HOME = "${dataHome}";
    XDG_CACHE_HOME = "${cacheHome}";

    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configHome}/java";
    ERRFILE = "${cacheHome}/x11/xsession-errors";
    GNUPGHOME = "${dataHome}/GNUPG";
    ICEAUTHORITY = "${cacheHome}/ICEauthority";
    KERAS_HOME = "${stateHome}/keras";
    LESSHISTFILE = "${stateHome}/less_history";
    PARALLEL_HOME = "${configHome}/parallel";
    PASSWORD_STORE_DIR = "${dataHome}/pass";
    SQLITE_HISTORY = "${cacheHome}/sqlite_history";
    TERMINFO = "${dataHome}/terminfo";
    TERMINFO_DIRS = "${dataHome}/terminfo:/usr/share/terminfo";
    USERXSESSIONRC = "${cacheHome}/x11/xsessionrc";
  };

  home.packages = [ pkgs.coreutils ];

  home.shellAliases = {
    "untar" = "tar -xvf";
    "confdir" = "cd ~/.config/NixOS-Config";
    "grep" = "echo 'Consider using ripgrep [rg] or batgrep instead'";
    "nvdir" = "cd ~/.config/NixOS-Config/homemanager/pkgs/neovim";
    "printenv" = "printenv | sort";
    "wget" = "wget --hsts-file=''$XDG_DATA_HOME/wget_hsts";
  };

  home.preferXdgDirectories = true;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    use-xdg-base-directories = true; # throws warning but is needed for correct location of hm-session-variables.sh
  };

  nixpkgs.config = pkgs-config;
  home.username = user;
  home.homeDirectory = homeDirectory;
  programs.home-manager.enable = true;
}
