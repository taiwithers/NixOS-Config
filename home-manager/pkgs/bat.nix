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

  home.file =
    let
      owner = "nk9";
      repo = "just_sublime";
      rev = "4148-1.1.5";
    in
    {
      "${config.common.configHome}/bat/syntaxes/just".source = pkgs.fetchgit {
        url = "https://github.com/${owner}/${repo}";
        inherit rev;
        hash = "sha256-Ww3eOd+isu0M83xwKDA5v3iuZ8uFABqk5//GR2MrYN0=";
        sparseCheckout = [
          "/Syntax/Comments.tmPreferences"
          "/Syntax/Just.sublime-syntax"
        ];

      };

    };
}
