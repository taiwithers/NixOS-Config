{
  config,
  pkgs,
  colours,
  ...
}:
{
  home.packages = [
    pkgs.rofi-bluetooth
  ];
  programs.rofi = rec {
    enable = true;
    package = pkgs.rofi-wayland.override {
      inherit plugins;
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
      matching = "normal";
      drun-match-fields = "name";
      show-icons = true;
      drun-display-format = "{name}"; # [<span weight='light' size='small'><i>({exec})</i></span>]";
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
    theme = with config.lib.formats.rasi; {
      # Modified from
      # Author : Aditya Shakya (adi1090x)
      # Github : @adi1090x
      configuration = {
        show-icons = false;
        display-drun = " Apps";
        display-run = " Run";
        display-filebrowser = " Files";
        display-window = " Windows";
        display-ssh = " SSH";
        display-calc = "󰪚 Calc";
      };

      ###         Global Properties
      "*" = with colours.hex-hash; {
        font = "Space Mono Nerd Font 12";
        background = mkLiteral navy;
        background-alt = mkLiteral dark-blue;
        foreground = mkLiteral ivory;
        selected = mkLiteral cyan;
        active = mkLiteral green;
        urgent = mkLiteral red;
        border-colour = mkLiteral "var(selected)";
        handle-colour = mkLiteral "var(selected)";
        background-colour = mkLiteral "var(background)";
        foreground-colour = mkLiteral "var(foreground)";
        alternate-background = mkLiteral "var(background-alt)";
        normal-background = mkLiteral "var(background)";
        normal-foreground = mkLiteral "var(foreground)";
        urgent-background = mkLiteral "var(urgent)";
        urgent-foreground = mkLiteral "var(background)";
        active-background = mkLiteral "var(active)";
        active-foreground = mkLiteral "var(background)";
        selected-normal-background = mkLiteral "var(selected)";
        selected-normal-foreground = mkLiteral "var(background)";
        selected-urgent-background = mkLiteral "var(active)";
        selected-urgent-foreground = mkLiteral "var(background)";
        selected-active-background = mkLiteral "var(urgent)";
        selected-active-foreground = mkLiteral "var(background)";
        alternate-normal-background = mkLiteral "var(background)";
        alternate-normal-foreground = mkLiteral "var(foreground)";
        alternate-urgent-background = mkLiteral "var(urgent)";
        alternate-urgent-foreground = mkLiteral "var(background)";
        alternate-active-background = mkLiteral "var(active)";
        alternate-active-foreground = mkLiteral "var(background)";
      };

      ###         Main Window
      window = {
        # properties for window widget
        transparency = "real";
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        fullscreen = false;
        width = mkLiteral "700px";
        x-offset = mkLiteral "0px";
        y-offset = mkLiteral "0px";

        # properties for all widgets
        enabled = true;
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "10px";
        border-color = mkLiteral "@border-colour";
        cursor = "default";
        # Backgroud Colors
        background-color = mkLiteral "@background-colour";
        ### Backgroud Image
        # background-image =          "url(\"/path/to/image.png\", none)";
        # Simple Linear Gradient
        # background-image =          "linear-gradient(red, orange, pink, purple)";
        # Directional Linear Gradient
        # background-image =          "linear-gradient(to bottom, pink, yellow, magenta)";
        # Angle Linear Gradient
        # background-image =          "linear-gradient(45, cyan, purple, indigo)";
      };

      ###         Main Box
      mainbox = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "20px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "0px 0px 0px 0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        children = [
          "inputbar"
          "message"
          "custombox"
        ];
      };

      ###         A Custom Box
      custombox = {
        spacing = mkLiteral "0px";
        background-color = mkLiteral "@background-colour";
        text-color = mkLiteral "@foreground-colour";
        orientation = mkLiteral "horizontal";
        children = [
          "mode-switcher"
          "listview"
        ];
      };

      ###         Inputbar
      inputbar = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "8px 12px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "8px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "@alternate-background";
        text-color = mkLiteral "@foreground-colour";
        children = [
          "textbox-prompt-colon"
          "entry"
        ];
      };

      prompt = {
        enabled = true;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      textbox-prompt-colon = {
        enabled = true;
        padding = mkLiteral "5px 0px";
        expand = false;
        str = " ";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      entry = {
        enabled = true;
        padding = mkLiteral "5px 0px";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "text";
        placeholder = "Search...";
        placeholder-color = mkLiteral "inherit";
      };
      num-filtered-rows = {
        enabled = true;
        expand = false;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      textbox-num-sep = {
        enabled = true;
        expand = false;
        str = "/";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      num-rows = {
        enabled = true;
        expand = false;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      case-indicator = {
        enabled = true;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      ###         Listview
      listview = {
        enabled = true;
        columns = 1;
        lines = 6;
        dynamic = true;
        scrollbar = false;
        layout = mkLiteral "vertical";
        reverse = false;
        fixed-height = true;
        fixed-columns = true;

        spacing = mkLiteral "5px";
        margin = mkLiteral "0px";
        padding = mkLiteral "10px";
        border = mkLiteral "2px 2px 2px 0px";
        border-radius = mkLiteral "0px 8px 8px 0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
        cursor = "default";
      };
      scrollbar = {
        handle-width = mkLiteral "5px";
        handle-color = mkLiteral "@handle-colour";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "@alternate-background";
      };

      ###         Elements
      element = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "10px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "8px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
        cursor = mkLiteral "pointer";
      };
      "element normal.normal" = {
        background-color = mkLiteral "var(normal-background)";
        text-color = mkLiteral "var(normal-foreground)";
      };
      "element normal.urgent" = {
        background-color = mkLiteral "var(urgent-background)";
        text-color = mkLiteral "var(urgent-foreground)";
      };
      "element normal.active" = {
        background-color = mkLiteral "var(active-background)";
        text-color = mkLiteral "var(active-foreground)";
      };
      "element selected.normal" = {
        background-color = mkLiteral "var(selected-normal-background)";
        text-color = mkLiteral "var(selected-normal-foreground)";
      };
      "element selected.urgent" = {
        background-color = mkLiteral "var(selected-urgent-background)";
        text-color = mkLiteral "var(selected-urgent-foreground)";
      };
      "element selected.active" = {
        background-color = mkLiteral "var(selected-active-background)";
        text-color = mkLiteral "var(selected-active-foreground)";
      };
      "element alternate.normal" = {
        background-color = mkLiteral "var(alternate-normal-background)";
        text-color = mkLiteral "var(alternate-normal-foreground)";
      };
      "element alternate.urgent" = {
        background-color = mkLiteral "var(alternate-urgent-background)";
        text-color = mkLiteral "var(alternate-urgent-foreground)";
      };
      "element alternate.active" = {
        background-color = mkLiteral "var(alternate-active-background)";
        text-color = mkLiteral "var(alternate-active-foreground)";
      };
      "element-icon" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        size = mkLiteral "24px";
        cursor = mkLiteral "inherit";
      };
      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        highlight = mkLiteral "inherit";
        cursor = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };

      ###         Mode Switcher
      mode-switcher = {
        enabled = true;
        expand = false;
        orientation = mkLiteral "vertical";
        spacing = mkLiteral "0px";
        margin = mkLiteral "0px";
        padding = mkLiteral "0px 0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "8px 0px 0px 8px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "@alternate-background";
        text-color = mkLiteral "@foreground-colour";
      };
      button = {
        padding = mkLiteral "0px 20px 0px 20px";
        border = mkLiteral "0px 2px 0px 0px";
        border-radius = mkLiteral "0px 0px 0px 0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
        cursor = mkLiteral "pointer";
      };
      "button selected" = {
        border = mkLiteral "2px 0px 2px 2px";
        border-radius = mkLiteral "8px 0px 0px 8px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "var(selected-normal-foreground)";
        text-color = mkLiteral "var(selected-normal-background)";
      };

      ###         Message
      message = {
        enabled = true;
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "0px 0px 0px 0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
      };
      textbox = {
        padding = mkLiteral "12px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "8px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "@alternate-background";
        text-color = mkLiteral "@foreground-colour";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
        highlight = mkLiteral "none";
        placeholder-color = mkLiteral "@foreground-colour";
        blink = true;
        markup = true;
      };
      error-message = {
        padding = mkLiteral "10px";
        border = mkLiteral "2px solid";
        border-radius = mkLiteral "8px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "@background-colour";
        text-color = mkLiteral "@foreground-colour";
      };
    };

    pass = {
      enable = false;
      extraConfig = "";
      # package = pkgs.rofi-pass-wayland;
      stores = [ ];
    };

  };
}
