{
  config,
  pkgs,
  selectAvailableTheme,
  ...
}: let
  # get profile string with `dconf dump /com/gexperts/Tilix/profiles`
  profileString = "2b7c4080-0ddd-46c5-8f23-563fd3ba789d";
in {
  dconf.settings."com/gexperts/Tilix" = {
    control-scroll-zoom = true;
    enable-wide-handle = true;
    middle-click-close = true;
    new-instance-mode = "new-session";
    # new-instance-mode = "focus-window";
    paste-strip-first-char = true;
    paste-strip-trailing-whitespace = true;
    prompt-on-close = true;
    terminal-title-style = "small";
    theme-variant = "dark";
    use-tabs = true;
  };

  # download all base 16 themes to tilix theme directory
  xdg.configFile."${config.xdg.configHome}/tilix/schemes/".source = pkgs.fetchFromGitHub {
    owner = "karlding";
    repo = "base16-tilix";
    rev = "72602d8";
    hash = "sha256-QFNiQNGD6ceE1HkLESx+gV0q/pKyr478k2zVy9cc7xI=";
  };

  # set tilix theme
  dconf.settings."com/gexperts/Tilix/profiles/${profileString}" = let
    getThemePath = name: "${config.xdg.configHome}/tilix/schemes/tilix/base16-${name}.json";
    tilixTheme = getThemePath (selectAvailableTheme getThemePath);
  in
    {font = "SpaceMono Nerd Font 12";} # items here have priority
    // (builtins.fromJSON (builtins.readFile tilixTheme));

  # dconf.settings."com/gexperts/Tilix/profiles/${profileString}".font = "SpaceMono Nerd Font 12";
}
