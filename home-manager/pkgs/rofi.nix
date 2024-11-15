{
  config,
  pkgs,
  colours,
  ...
}:
{
  home.packages = [pkgs.rofi-bluetooth pkgs.keepmenu];
  programs.rofi = rec {
    enable = true;
    package = pkgs.rofi-wayland.override {
      plugins = plugins;
    }; # rofi-wayland, rofi-wayland-unwrapped
    plugins = with pkgs; [
      rofi-calc
      # rofimoji
      # rofi-emoji
      # rofi-emoji-wayland
      # rofi-games
      # rofi-systemd
    ];

    cycle = false; # cycle through results
    extraConfig = rec {
      modes = "drun,run,filebrowser,calc";
      case-sensitive = false;
      scroll-method = 1; # 1 continuous
      normalize-match = true; # match accented and nonaccented characters
      steal-focus = true;
      matching = "fuzzy";
      drun-match-fields = "name";
      show-icons = true;
      drun-display-format = "{name} [<span weight='light' size='small'><i>({exec})</i></span>]";
      drun-show-actions = false;
      window-match-field = "all";

      auto-select = true;
      # matching-negate-char = "!";

      window-format = "{n} - {t} [{w}]";
      window-thumbnail = true;

      combi-modes = modes;
      combi-display-format = "{text} [{mode}]";

      # fixed-num-lines = true; # theme option

      global-kb = false;

      kb-secondary-paste = "Control+v"; # primary is selection, secondary is clipboard
      kb-secondary-copy = "Control+c";
      kb-clear-line = "Control+Shift+BackSpace";
      # kb-move-front = "Control+a,Home,KP_Home";
      # kb-move-end = "Control+e,End,KP_End";
      kb-move-word-back = "Control+Left";
      kb-move-word-forward = "Control+Right";
      kb-move-char-back = "Left";
      kb-move-char-forward = "Right";
      kb-remove-word-back = "Control+BackSpace,Control+w";
      kb-remove-word-forward = "Control+Delete";
      kb-remove-char-back = "BackSpace";
      kb-remov-char-forward = "Delete";
      kb-remove-to-eol = "Control+k";
      kb-remove-to-sol = "Control+u";
      kb-accept-entry = "Return,KP_Enter";
      kb-accept-custom = "";
      kb-accept-custom-alt = "";
      kb-delete-entry = "";
      kb-accept-alt = "";
      kb-mode-complete = "";
      kb-row-left = "";
      kb-row-right = "";
      kb-element-prev = "";
      kb-page-prev = "";
      kb-page-next = "";
      kb-row-select = "";
      kb-screenshot = "";
      kb-ellipsize = "";
      kb-toggle-case-sensitivity = "";
      kb-mode-next = "Tab";
      kb-element-next = ""; # would otherwise override tab
      kb-mode-previous = "Shift+Tab";
      kb-row-down = "Down,Alt+j";
      kb-row-up = "Up,Alt+k";
      kb-cancel = "Escape,Control+bracketleft";
    };
    # font = "Liberation Mono 16";
    location = "center";
    theme = "launcher-type1-style9";

    pass = {
      enable = false;
      extraConfig = "";
      # package = pkgs.rofi-pass-wayland;
      stores = [ ];
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
  xdg.configFile."rofi/shared/fonts.rasi".text = '''';
}
