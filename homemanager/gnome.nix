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
      favorite-apps = [
        "firefox.desktop"
        "nautilus.desktop"
        # "org.gnome.Nautilus.desktop"
        "codium.desktop"
        "obsidian.desktop"
        "sublime_text.desktop"
        # "zotero.desktop"
        "gnome-console.desktop"
      ];
    };

    "org/gnome/desktop/interface" = {
      color-sceme = "prefer-dark";
      enable-hot-corners = false;
    };
  };
}
