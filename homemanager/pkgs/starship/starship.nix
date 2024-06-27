{
  config,
  ...
}: let
  # colours = builtins.mapAttrs (name: value: "#" + value) theme-config.colours.palette;
in {
  # style strings (not case sensitive)
  # bold, italic, underline, dimmed, inverted, blink, hidden, strikethrough, <color>, fg:<color>, bg:<color>, none
  # colors: black, red, green, blue, yellow, purple, cyan, white, bright-<any of previous>, #hexcode, 0-255 ANSI code

  programs.starship.enable = true;
  programs.starship.enableZshIntegration = false;
  xdg.configFile."${config.xdg.configHome}/starship.toml" = {
    source = ./starship.toml;
  };
}
