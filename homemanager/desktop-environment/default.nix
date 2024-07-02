{
  # config,
  # pkgs,
  ...
}:
{
  imports = map (fname: ./. + "/${fname}" + ".nix") [
    "autostart-programs"
    "fonts"
    "shell"
    "taskbar-programs"
    "xdg"
  ];
}
