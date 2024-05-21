{
  config,
  pkgs,
  # unstable-pkgs,
  ...
}: {
  imports = map (fname: ./. + "/${fname}" + ".nix") [
    # ./autostart-programs.nix
    # ./fonts.nix
    # ./gnome.nix
    # ./gnome-extensions.nix
    # ./gnome-keybinds.nix
    # ./shell.nix
    # ./taskbar-programs.nix
    # ./xdg.nix
    "autostart-programs"
    "fonts"
    "gnome"
    "gnome-extensions"
    "gnome-keybinds"
    "shell"
    "taskbar-programs"
    "xdg"
  ];
}
