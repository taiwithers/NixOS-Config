{
  config,
  pkgs,
  ...
}:
{
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batgrep
      batman
      batpipe
      batwatch
      prettybat
    ];

    # config = {
    #   theme = "base16";
    # };
  };
  home.shellAliases = {
    "man" = "bman";
    "cat" = "bat --plain";
    "bsession" = "bat ${config.common.hm-session-vars}";
  };

  home.sessionVariables."BATDIFF_USE_DELTA" = "true";

  programs.bash.bashrcExtra = ''
    # workaround for most bat themes not providing syntax highlighting
    bman() {
        ( BAT_THEME="Monokai Extended" batman "$@" )
      }

    eval "$(${pkgs.bat-extras.batpipe}/bin/batpipe)"
  '';
}
