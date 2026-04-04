{
  config,
  niri,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    beep
    brightnessctl
    sox # for notification beeps
    # play --null --no-show-progress synth 1 sin 200/300 sin 300/200 remix 1,2 channels 2
  ];
  imports = [ niri.homeModules.niri ];
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;
  programs.niri.settings = {
    layout = {
      gaps = 12;
    };
    binds = with config.lib.niri.actions; {
      # niri management
      "Super+Shift+Slash" = {
        action = show-hotkey-overlay;
        hotkey-overlay.title = "Show hotkey overlay";
      };
      "Super+Shift+E" = {
        action = quit;
        hotkey-overlay.title = "Quit Niri";
      };
      "Super+Tab" = {
        action = toggle-overview;
        hotkey-overlay.title = "Open overview";
      };

      # Application launching
      "Super+T" = {
        action.spawn = "kitty";
        hotkey-overlay.title = "Launch kitty";
      };
      "Super+Space" = {
        action.spawn = [
          "rofi"
          "-show"
        ];
        hotkey-overlay.title = "Launch rofi";
        repeat = false;
      };

      # Window focusing
      "Alt+h" = {
        action = focus-column-left;
        hotkey-overlay.title = "Focus column left";
      };
      "Alt+j" = {
        action = focus-window-down;
        hotkey-overlay.title = "Focus window down";
      };
      "Alt+k" = {
        action = focus-window-up;
        hotkey-overlay.title = "Focus window up";
      };
      "Alt+l" = {
        action = focus-column-right;
        hotkey-overlay.title = "Focus column right";
      };

      # Window moving
      "Alt+Shift+h" = {
        action = move-column-left;
        hotkey-overlay.title = "Move column left";
      };
      "Alt+Shift+j" = {
        action = move-window-down;
        hotkey-overlay.title = "Move window down";
      };
      "Alt+Shift+k" = {
        action = move-window-up;
        hotkey-overlay.title = "Move window up";
      };
      "Alt+Shift+l" = {
        action = move-column-right;
        hotkey-overlay.title = "Move column right";
      };

      # other window actions
      "Alt+m" = {
        action = maximize-window-to-edges;
        hotkey-overlay.title = "Maximize window";
      };
      "Alt+f" = {
        action = toggle-window-floating;
        hotkey-overlay.title = "Float window";
      };
      "Alt+t" = {
        action = toggle-column-tabbed-display;
        hotkey-overlay.title = "Toggle column as tabs";
      };

      # scroll left/right on touchpad w/ three finger drag
      # open overview with four finger drag up
      # move windows with mod and left mouse drag
      # resize windows with mod and right mouse drag

      # leaving out window/column move keys for now
      # and first/last column keys
      # and monitor focus/move keys
      # and workspace keys
      # and single-window keys
      # and resizing keys
      "Print" = {
        action.screenshot = {
          show-pointer = false;
        };
        hotkey-overlay.title = "Screenshot";
      };
      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn-sh = [
          "brightnessctl --class=backlight set +10%"
        ];
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = [
          "brightnessctl --class=backlight set 10%-"
        ];
      };
      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      };
    };
    prefer-no-csd = true; # prefer SSD
    # spawn-at-startup = [
    #   { command = [ "xwayland-satellite" ]; }
    # ];
    # environment = {
    #   DISPLAY = ":0";
    # };

  };

}
