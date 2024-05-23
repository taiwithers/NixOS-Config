{config, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [];
    settings = {
      "$terminal" = "tilix";
      "$fileManager" = "dolphin";
    };
  };

  # xdg.configFile."${config.xdg.configHome}/hypr/hyprland.conf".text = ''

  #   $terminal = tilix
  # '';
}
