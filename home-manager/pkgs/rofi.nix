{
  config,
  pkgs,
  colours,
  ...
}:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland-unwrapped; # rofi-wayland, rofi-wayland-unwrapped
    plugins = with pkgs; [
      # rofi-calc
      # rofimoji
      # rofi-emoji
      # rofi-emoji-wayland
      # rofi-top
      # rofi-games
      # rofi-systemd
      # rofi-bluetooth
      # keepmenu
    ];

    cycle = true; # cycle through results
    extraConfig = rec {
      modes = "window,drun,run,ssh,filebrowser";
      case-sensitive = false;
      scroll-method = 1; # 1 continuous
      normalize-match = true; # match accented and nonaccented characters
      steal-focus = true;
      matching = "fuzzy";
      drun-match-fields = "name,exec";
      show-icons = true;
      drun-display-format = "{name} [<span weight='light' size='small'><i>({exec})</i></span>]";
      drun-show-actions = true;
      window-match-field = "all";
      # matching-negate-char = "!";

      terminal = "$TERMINAL";
      window-format = "{n} - {t} [{w}]";
      window-thumbnail = true;
      
      combi-modes = modes;
      combi-display-format = "{text} [{mode}]";

      # fixed-num-lines = true; # theme option

    };
    font = "Liberation Mono 16";
    location = "center";
    theme = "launcher-type1-style9";

    pass = {
      enable = false;
      extraConfig = "";
      # package = pkgs.rofi-pass-wayland;
      stores = [];
    };

  };

  xdg.configFile."rofi/launcher-type1-style9.rasi".source = ./theme.rasi;
  xdg.configFile."rofi/shared/colors.rasi".text = with colours.hex-hash; ''
    * {
        background: ${navy};
        background-alt: ${dark-blue};
        foreground: ${ivory};
        selected: ${cyan};
        active: ${green};
        urgent: ${red};
      }
  '';
  xdg.configFile."rofi/shared/fonts.rasi".text = '' '';
}
