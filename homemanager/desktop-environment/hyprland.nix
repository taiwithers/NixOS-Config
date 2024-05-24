{config, ...}: {
  xdg.desktopEntries.hyprland = {
    name = "hyprland";
    exec = "Hyprland";
    terminal = false;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [];
    settings = {
      "$mainMod" = "SUPER"; # set windows key as primary modifier
      "$terminal" = "tilix";
      "$fileManager" = "dolphin";

      # keybindings
      bind = [
        "$mainMod, M, exit" # super + M : exit hyprland
        "$mainMod, E, exec, $fileManager" # super + E : open filemanager
        "$mainMod, I, exec, gnome-control-center"
        "$mainMod, Q, exec, gnome-terminal"
      ];

      misc."disable_hyprland_logo" = true;

      # on startup
      exec-once = [
        "swaybg --mode=fill --image=/run/current-system/sw/share/backgrounds/gnome/adwaita-d.jpg"
        "eww daemon"
        "eww open example"
      ];
    };
  };
}
