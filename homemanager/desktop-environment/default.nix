{
  config,
  pkgs,
  ...
}: {
  imports = map (fname: ./. + "/${fname}" + ".nix") [
    "autostart-programs"
    "fonts"
    "gnome"
    "gnome-extensions"
    "gnome-keybinds"
    "hyprland"
    "shell"
    "taskbar-programs"
    "xdg"
  ];
}
