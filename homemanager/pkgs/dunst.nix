{ ... }:
{
  services.dunst.enable = true;
  services.dunst.waylandDisplay = "wayland-0";

  # see default config: bat $(get-package-dir)/etc/dunst/dunstrc
  services.dunst.settings = {
    global = {
      monitor = 0;
      notification_limit = 0; # 0 -> no limit
      show_indicators = "yes";
      force_xwayland = false;

      # geometry/positioning
      origin = "top-right";
      offset = "10x50";

      # aesthetics
      separator_height = 2; # pixels between notifications
      frame_width = 3; # window frame width
      frame_color = "#aaaaaa";
      corner_radius = 0;
    };
  };
}
