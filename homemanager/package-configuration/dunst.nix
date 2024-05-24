{...}: {
  services.dunst.enable = false;

  # see default config: bat $(get-package-dir)/etc/dunst/dunstrc
  services.dunst.settings = {
    global = {
      monitor = 0;

      # geometry/positioning
      origin = "top-right";
      offset = "10x50";

      notification_limit = 0; # 0 -> no limit
      separator_height = 2; # pixels between notifications
      frame_width = 3; # window frame width
      frame_color = "#aaaaaa";
    };
  };
}
