{pkgs, ...}: let
  # tidalwm = import ()
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

    # access with: gnome-extensions list
    enabled-extensions = map (ext: ext.extensionUuid) home.packages;
    # [
    #   "extension-list@tu.berry"
    #   "favourites-in-appgrid@harshadgavali.gitlab.org"
    #   "gTile@vibou"
    #   "start-overlay-in-application-view@Hex_cz"
    #   "AlphabeticalAppGrid@stuarthayhurst"
    #   "click-to-close-overview@l3nn4rt.github.io"
    #   "ding@rastersoft.com"
    #   "steal-my-focus-window@steal-my-focus-window"
    #   "appindicatorsupport@rgcjonas.gmail.com"
    #   "all-windows@ezix.org"
    #   "dash-to-panel@jderose9.github.com"
    #   "forge@jmmaranan.com"
    # ];
  };
}
