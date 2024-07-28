{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  app-themes,
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

    GNUPGHOME = "${dataHome}/GNUPG";
    ICEAUTHORITY = "${cacheHome}/ICEauthority";
    TERMINFO = "${dataHome}/terminfo";
    TERMINFO_DIRS = "${dataHome}/terminfo:/usr/share/terminfo";
    PARALLEL_HOME = "${configHome}/parallel";
    PASSWORD_STORE_DIR = "${dataHome}/pass";
    KERAS_HOME = "${stateHome}/keras";
    SQLITE_HISTORY = "${cacheHome}/sqlite_history";
    ERRFILE = "${cacheHome}/x11/xsession-errors";
    USERXSESSIONRC = "${cacheHome}/x11/xsessionrc";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configHome}/java";
  };

  nixpkgs.config = pkgs-config;

  home.username = user;
  home.homeDirectory = homeDirectory;
  programs.home-manager.enable = true;
}
