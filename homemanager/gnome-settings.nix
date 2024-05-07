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
    dash-to-panel
    favourites-in-appgrid
    forge
    gtile
    start-overlay-in-application-view
    steal-my-focus-window
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      # taskbar apps
      favorite-apps = [
        "firefox.desktop"
        # "nautilus.desktop"
        "org.kde.dolphin.desktop"
        "sublime_text.desktop"
        # "org.gnome.Console.desktop"
        "com.gexperts.Tilix.desktop"
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
        "appindicatorsupport@rgcjonas.gmail.com"
        "all-windows@ezix.org"
        "dash-to-panel@jderose9.github.com"
        "forge@jmmaranan.com"
      ];
    };

    "org/gnome/desktop/interface" = {
      color-sceme = "prefer-dark";
      show-battery-percentage = true;
      overlay-scrolling = true;
      locate-pointer = true;
    };

    "org/gnome/settings-daemon/plugins/power".power-button-action = "interactive";

    # multitasking
    "org/gnome/desktop/interface".enable-hot-corners = false;
    "org/gnome/mutter".edge-tiling = true;
    "org/gnome/mutter".dynamic-workspaces = true;
    "org/gnome/mutter".workspaces-only-on-primary = false;
    "org/gnome/shell/app-switcher".current-workspace-only = true;

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
      # under navigation
      move-to-monitor-down = [];
      move-to-monitor-left = [];
      move-to-monitor-right = [];
      move-to-monitor-up = [];
      move-to-workspace-left = [];
      move-to-workspace-right = [];
      move-to-workspace-last = [];
      move-to-workspace-1 = [];
      move-to-workspace-2 = [];
      switch-panels = []; # "switch system controls"
      switch-panels-backward = []; # ??
      cycle-panels = []; # "switch system controls directly"
      cycle-panels-backward = []; # ??
      switch-to-workspace-last = [];
      switch-to-workspace-1 = [];
      switch-to-workspace-left = [];
      switch-to-workspace-right = [];
      cycle-windows = []; # "switch windows directly"
      cycle-windows-backward = []; # ??
      cycle-group = []; # "switch windows of an app directly"
      cycle-group-backward = [];
      switch-group = []; # "switch windows of an application"
      switch-group-backward = [];

      # under window section
      activate-window-menu = [];
      minimize = ["<Super>Down"];
      unmaximize = [];
      toggle-maximized = [];
    };

    # screenshot keybindings
    "org/gnome/shell/keybindings" = {
      show-screen-recording-ui = []; # "record a screencast interactively"
      screenshot = ["<Super>Print"]; # take a screenshot
      show-screenshot-ui = ["Print"]; # take a screenshot interactively
      screenshot-window = [];
    };

    # system
    "org/gnome/shell/keybindings".focus-active-notification = [];
    "org/gnome/shell/keybindings".toggle-quick-settings = [];
    "org/gnome/shell/keybindings".restore-shortcuts = [];
    "org/gnome/shell/keybindings".toggle-application-view = [];
    "org/gnome/shell/keybindings".toggle-message-tray = [];
    "org/gnome/shell/keybindings".switch-input-source = [];
    "org/gnome/shell/keybindings".switch-input-source-backward = [];
    "org/gnome/settings-daemon/plugins/media-keys".logout = [];

    # custom keybindings
    "org/gnome/desktop/wm/keybindings" = {
      custom-keybindings = [
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Open Nautilus";
      command = "nautilus";
      binding = "<Super>e";
    };
  };
}
