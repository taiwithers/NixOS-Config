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
        "$mainMod, M, exit" # super + M : exit hyprland
        "$mainMod, E, exec, $fileManager" # super + E : open filemanager
        "$mainMod, I, exec, gnome-control-center"
      ];

      "disable_hyprland_logo" = true;

      # on startup
      exec-once = [
        ''          swaybg \
                      --mode=fill \
                      --image=/run/current-system/sw/share/background/gnome/adwaita-d.jpg''
      ];
    };
  };
}
# swaybg --mode fill -image /run/current-system/sw/share/background/gnome/adwaita-d.jpg

