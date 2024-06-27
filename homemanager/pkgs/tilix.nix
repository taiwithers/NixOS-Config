{
  config,
  pkgs,
  app-themes,
  ...
}: let
  # get profile string with `dconf dump /com/gexperts/Tilix/profiles`
  profileString = "2b7c4080-0ddd-46c5-8f23-563fd3ba789d";
  tilixThemeFile = "${config.xdg.configHome}/tilix/schemes/base16-theme.json";
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

  dconf.settings."com/gexperts/Tilix/profiles/${profileString}" = with app-themes.palettes.tilix;
    # items here have priority
    {
      font = "SpaceMono Nerd Font 12";
      cursor-colors-set = true;
      highlight-colors-set = true;
      bold-color-set = true;
      badge-color-set = true;
      bold-is-bright = false;
    }
    # https://github.com/karlding/base16-tilix/blob/master/templates/default.mustache
    // (builtins.fromJSON ''
      {   "background-color": "#${base00}",
          "badge-color": "#${base08}",
          "comment": "",
          "cursor-background-color": "#${base04}",
          "cursor-foreground-color": "#${base04}",
          "dim-color": "#${base01}",
          "foreground-color": "#${base04}",
          "highlight-background-color": "#${base01}",
          "highlight-foreground-color": "#${base04}",
          "name": "base16",
          "palette": [
              "#${base00}",
              "#${base08}",
              "#${base0B}",
              "#${base0A}",
              "#${base0D}",
              "#${base0E}",
              "#${base0C}",
              "#${base05}",
              "#${base03}",
              "#${base08}",
              "#${base0B}",
              "#${base0A}",
              "#${base0D}",
              "#${base0E}",
              "#${base0C}",
              "#${base07}"
          ]}'');
}
