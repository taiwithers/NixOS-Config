{config, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [];
    settings = {
      "$mainMod" = "SUPER"; # set windows key as primary modifier
      "$terminal" = "tilix";
      "$fileManager" = "dolphin";

      # keybindings
      bind = [
        "$mainMod, M, exit"
      ];
    };
  };

  # home.file."testoutput".
}
