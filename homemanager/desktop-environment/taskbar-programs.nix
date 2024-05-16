{pkgs, ...}: let
  locateDesktop = import ../../nix-scripts/locate-desktop.nix;
in {
  dconf.settings."org/gnome/shell".favorite-apps = with pkgs;
    map (pkg: locateDesktop pkg) [
      firefox
      dolphin
      sublime4
      tilix
      vscodium-fhs
      obsidian
    ];
}
