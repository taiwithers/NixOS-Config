{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs.gnomeExtensions; [
    all-windows
    alphabetical-app-grid
    appindicator
    click-to-close-overview
    desktop-icons-ng-ding
    dock-from-dash
    favourites-in-appgrid
    gtile
    start-overlay-in-application-view
    steal-my-focus-window
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      # taskbar apps
      favorite-apps = [
        "firefox.desktop"
        "nautilus.desktop"
        "codium.desktop"
        "obsidian.desktop"
        "sublime_text.desktop"
        # "zotero.desktop"
        "org.gnome.Console.desktop"
      ];

      disable-user-extensions = false;

      # gnome-extensions list
      enabled-extensions = [
        "extension-list@tu.berry"
        "favourites-in-appgrid@harshadgavali.gitlab.org"
        "gTile@vibou"
        "start-overlay-in-application-view@Hex_cz"
        "AlphabeticalAppGrid@stuarthayhurst"
        "click-to-close-overview@l3nn4rt.github.io"
        "ding@rastersoft.com"
        "steal-my-focus-window@steal-my-focus-window"
        "dock-from-dash@fthx"
        "appindicatorsupport@rgcjonas.gmail.com"
        "all-windows@ezix.org"
      ];
    };

    "org/gnome/desktop/interface" = {
      color-sceme = "prefer-dark";
      enable-hot-corners = false;
    };
  };
}
