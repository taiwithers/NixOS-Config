{
  config,
  pkgs,
  ...
}: {
  environment.gnome.excludePackages = with pkgs; [
    gnome-connections # remote desktop
    gnome.geary # mail app
    gnome.yelp # help viewer
    gnome.gnome-calendar
    gnome.gnome-characters
    gnome.gnome-contacts
    gnome.gnome-logs
    gnome.gnome-maps
    gnome.gnome-music
    gnome.gnome-weather
  ];
}
