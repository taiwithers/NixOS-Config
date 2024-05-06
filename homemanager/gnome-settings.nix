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
        "sublime_text.desktop"
        "org.gnome.Console.desktop"
        "codium.desktop"
        "obsidian.desktop"
        # "zotero.desktop"
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

    # media and accessibility keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
      screenreader = [];
      magnifier = [];
      magnifier-zoom-in = [];
      magnifier-zoom-out = [];
      help = [];
    };

    # window managment keybindings
    "org/gnome/desktop/wm/keybindings" = {
      move-to-monitor-down = [];
      move-to-monitor-left = [];
      move-to-monitor-right = [];
      move-to-monitor-up = [];
      move-to-workspace-left = [];
      move-to-workspace-right = [];
      move-to-workspace-last = [];
      move-to-workspace-1 = [];
      move-to-workspace-2 = [];
    };
  };
}
