{
  config,
  pkgs,
  ...
}:
{
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      # batdiff
      batgrep
      batman
      # batpipe
    ];

    config = {
      theme = "base16";
    };
  };
  home.shellAliases = {
    "man" = "bman";
    "cat" = "bat --plain";
    "bsession" = "bat ${config.common.hm-session-vars}";
  };

  programs.bash.bashrcExtra = ''
    # workaround for most bat themes not providing syntax highlighting
    bman() {
        ( BAT_THEME="Monokai Extended" batman "$@" )
      }
  '';
}
