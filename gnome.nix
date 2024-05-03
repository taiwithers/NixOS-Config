{
  config,
  pkgs,
  ...
}: {
  environment.gnome.excludePackages = with pkgs; [
    gnome-connections # remote desktop
    gnome.geary # mail app
  ];
}
