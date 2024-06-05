{
  config,
  pkgs,
  theme-config,
  ...
}: let
  getThemePath = name: "${config.xdg.configHome}/tilix/schemes/tilix/base16-${name}.json";

  # get profile string with `dconf dump /com/gexperts/Tilix/profiles`
  profileString = "2b7c4080-0ddd-46c5-8f23-563fd3ba789d";
  # tilixTheme = getThemePath (theme-config.selectAvailableTheme getThemePath);

  tilixThemeFile = "${config.xdg.configHome}/tilix/schemes/base16-theme.json";
  colours = theme-config.colour-palette;
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

  # https://github.com/karlding/base16-tilix/blob/master/templates/default.mustache
  xdg.configFile."${tilixThemeFile}".text = ''
    {    "background-color": "#${colours.base00}",
        "badge-color": "#${colours.base08}",
        "comment": "",
        "cursor-background-color": "#${colours.base04}",
        "cursor-foreground-color": "#${colours.base04}",
        "dim-color": "#${colours.base01}",
        "foreground-color": "#${colours.base04}",
        "highlight-background-color": "#${colours.base01}",
        "highlight-foreground-color": "#${colours.base04}",
        "name": "${builtins.head theme-config.names} (base16)",
        "palette": [
            "#${colours.base00}",
            "#${colours.base08}",
            "#${colours.base0B}",
            "#${colours.base0A}",
            "#${colours.base0D}",
            "#${colours.base0E}",
            "#${colours.base0C}",
            "#${colours.base05}",
            "#${colours.base03}",
            "#${colours.base08}",
            "#${colours.base0B}",
            "#${colours.base0A}",
            "#${colours.base0D}",
            "#${colours.base0E}",
            "#${colours.base0C}",
            "#${colours.base07}"
        ]}
  '';

  dconf.settings."com/gexperts/Tilix/profiles/${profileString}" =
    # items here have priority
    {
      font = "SpaceMono Nerd Font 12";
      cursor-colors-set = true;
      highlight-colors-set = true;
      bold-color-set = true;
      badge-color-set = true;
      bold-is-bright = false;
    }
    // (builtins.fromJSON (builtins.readFile tilixThemeFile));
}
