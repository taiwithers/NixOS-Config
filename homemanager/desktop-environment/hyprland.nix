{config, ...}: {
  xdg.desktopEntries.hyprland = {
    name = "hyprland";
    exec = "Hyprland";
    terminal = false;

  xdg.configFile."${config.xdg.configHome}/hypr/hyprland-startup.sh".source = ./hyprland-startup.sh;

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
        "$mainMod, Q, exec, $terminal"
        "$mainMod, S, exec, rofi -show drun -show-icons"

      ];

      misc."disable_hyprland_logo" = true;

      # on startup
      exec-once = "bash ${config.xdg.configHome}/hypr/hyprland-startup.sh";
    };
  };
}
