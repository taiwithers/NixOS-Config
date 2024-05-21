{pkgs, ...}: let

  owner = "rustysec";
  repo = "tidalwm";
  version = 0;
  rev = "bbf055a";
  hash = "";

  ext = pkgs.stdenv.mkDerivation {
    pname = "gnome-shell-extension-${repo}";
    version = builtins.toString version;
    src = pkgs.fetchFromGitHub {
      owner = owner;
      repo = repo;
      rev = rev;
      hash = hash;
    };
  };
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
