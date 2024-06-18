{...}: {
  imports = [
    ./gnome-extensions.nix
    ./gnome-keybinds.nix
  ];
  dconf.settings = {
    "org/gtk/settings/file-chooser" = {clock-format = "12h";};

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      show-battery-percentage = true;
      overlay-scrolling = true;
      locate-pointer = true;
      clock-format = "12h";
      gtk-enable-primary-paste = false; # disable middle click paste
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
      primary-color = "#241f31";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
      primary-color = "#241f31";
      secondary-color = "#000000";
    };

    "org/gnome/settings-daemon/plugins/power".power-button-action = "interactive";

    # multitasking
    "org/gnome/desktop/interface".enable-hot-corners = false;
    "org/gnome/mutter".edge-tiling = true;
    "org/gnome/mutter".dynamic-workspaces = true;
    "org/gnome/mutter".workspaces-only-on-primary = false;
    "org/gnome/shell/app-switcher".current-workspace-only = true;
    "org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";
    "org/gnome/desktop/wm/preferences".focus-mode = "click";

    # themeing
    "org/gnome/desktop/interface".icon-theme = "Adwaita";
    "org/gnome/desktop/interface".gtk-theme = "adw-gtk3-dark";
  };
}
