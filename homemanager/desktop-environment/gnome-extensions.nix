{pkgs, ...}: let
  t = pkgs.desktops.gnome.extensions.buildGnomeExtension.nix;
in rec {
  home.packages = with pkgs.gnomeExtensions; [
    all-windows
    alphabetical-app-grid
    appindicator
    click-to-close-overview
    desktop-icons-ng-ding
    dash-to-panel
    favourites-in-appgrid
    forge
    # gtile
    start-overlay-in-application-view
    steal-my-focus-window
  ];

  dconf.settings."org/gnome/shell" = {
    disable-user-extensions = false;
    enabled-extensions = map (ext: ext.extensionUuid) home.packages;
  };
}
