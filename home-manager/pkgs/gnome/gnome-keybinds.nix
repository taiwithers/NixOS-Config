# TODO: add all keybinds here, not just modified ones
# waiting on dconf2nix update nixpkgs
{...}: let
  custom-keyboard-shortcuts = [
    {
      name = "Open Dolphin";
      command = "dolphin";
      binding = "<Super>e";
    }
    {
      name = "Open Settings";
      command = "gnome-control-center";
      binding = "<Super>i";
    }
  ];
in {
  imports = [
    (import ../../../scripts/set-custom-gnome-keybinds.nix {inherit custom-keyboard-shortcuts;})
  ];

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
      cycle-group-backward = [];
      cycle-group = []; # "switch windows of an app directly"
      cycle-panels-backward = []; # ??
      cycle-panels = []; # "switch system controls directly"
      cycle-windows-backward = []; # ??
      cycle-windows = []; # "switch windows directly"
      move-to-monitor-down = [];
      move-to-monitor-left = [];
      move-to-monitor-right = [];
      move-to-monitor-up = [];
      move-to-workspace-1 = [];
      move-to-workspace-2 = [];
      move-to-workspace-last = [];
      move-to-workspace-left = [];
      move-to-workspace-right = [];
      switch-application = []; # disable alt-tab window grouping
      switch-applications-backward = [];
      switch-group-backward = [];
      switch-group = []; # "switch windows of an application"
      switch-panels-backward = []; # ??
      switch-panels = []; # "switch system controls"
      switch-windows = ["<Alt>Tab"];
      switch-windows-backward = ["<Shift><Alt>Tab"];
      switch-to-workspace-1 = [];
      switch-to-workspace-last = [];
      switch-to-workspace-left = ["<Super><Shift>Left"];
      switch-to-workspace-right = ["<Super><Shift>Right"];

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
