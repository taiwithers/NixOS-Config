{
  config,
  niri,
  pkgs,
  ...
}:
let

  brightness-change = pkgs.writeShellApplication {
    name = "brightness-change";
    runtimeInputs = [
      pkgs.brightnessctl
      pkgs.bc
    ];
    text = ''
      set -euo pipefail

      if [[ $# -eq 0 ]]; then 
          echo "Missing argument \`up\` or \`down\`"
          exit 1
      else
          echo "Parameter passed = $1"
      fi


      function current_brightness(){
        value=$(bc <<< "$(brightnessctl get) * 100 / $(brightnessctl max)")
        echo "$value"
      }

      # check for early exit
      case $1 in
        up|max)
          if [[ $(current_brightness) -eq 100 ]]; then
            notify-send "Brightness already at maximum"
            exit 0
          fi
          ;;
        down|min)
          if [[ $(current_brightness) -le 10 ]]; then
            notify-send "Brightness already at minimum"
            exit 0
          fi
          ;;
      esac

      case $1 in 
        up)
          action="+10%"
          ;;
        down)
          action="10%-"
          ;;
        min)
          action="5%"
          ;;
        max)
          action="100%"
          ;;
        *)
          echo "Unknown command"
          exit 1
          ;;
      esac

      brightnessctl --class=backlight set $action
      notify-send "Set brightness to $(current_brightness)"
    '';
  };
in
{
  #--------------------------------------------------------------------#
  #                              Battery
  # With `upower` service enabled (NixOS config)
  # upower --enumerate # to find batteries
  # upower --show-info {battery name} | rg "percentage|state"
  #--------------------------------------------------------------------#

  home.packages = with pkgs; [
    brightnessctl
    sox # for notification beeps
    # play --null --no-show-progress synth 1 sin 200/300 sin 300/200 remix 1,2 channels 2
    brightness-change
  ];
  imports = [ niri.homeModules.niri ];
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;
  programs.niri.settings = {
    layout = {
      gaps = 12;
    };
    binds =
      with config.lib.niri.actions;
      {
        # niri management
        "Super+Shift+Slash".action = show-hotkey-overlay;
        "Super+Shift+E".action = quit;
        "Super+Tab".action = toggle-overview;

        # Application launching
        "Super+T".action.spawn = "kitty";
        "Super+Space" = {
          action.spawn = [
            "rofi"
            "-show"
          ];
          repeat = false;
        };

        # Window focusing
        "Alt+h".action = focus-column-left;
        "Alt+l".action = focus-column-right;
        "Alt+j" = {
          action = focus-window-down;
          hotkey-overlay.title = "Focus window down";
        };
        "Alt+k" = {
          action = focus-window-up;
          hotkey-overlay.title = "Focus window up";
        };

        # Window moving
        "Alt+Shift+h".action = move-column-left;
        "Alt+Shift+l".action = move-column-right;
        "Alt+Shift+j" = {
          action = move-window-down;
          hotkey-overlay.title = "Move window down";
        };
        "Alt+Shift+k" = {
          action = move-window-up;
          hotkey-overlay.title = "Move window up";
        };

        # other window actions
        "Alt+f".action = toggle-window-floating;
        "Alt+Shift+q".action = close-window;
        "Alt+m" = {
          action = maximize-column;
          # action = maximize-window-to-edges; # no borders/gaps
          hotkey-overlay.title = "Maximize window";
        };
        "Alt+t" = {
          action = toggle-column-tabbed-display;
          hotkey-overlay.title = "Toggle column as tabs";
        };

        # close-window, center-window, switch-preset-column-width

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
      }
      // ({
        "Print" = {
          action.screenshot = {
            show-pointer = false;
          };
        };
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action.spawn-sh = "brightness-change up";
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action.spawn-sh = "brightness-change down";
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
          action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && notify-send 'Microphone muted'";
        };
      });
    prefer-no-csd = true; # prefer SSD
    # spawn-at-startup = [
    #   { command = [ "xwayland-satellite" ]; }
    # ];
    # environment = {
    #   DISPLAY = ":0";
    # };

  };

}
