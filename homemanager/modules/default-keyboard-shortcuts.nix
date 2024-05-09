{...}: {
  dconf.settings = {
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
      switch-to-workspace-left = ["<Super><Shift>Left"];
      switch-to-workspace-right = ["<Super><Shift>Right"];
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
  };
}
