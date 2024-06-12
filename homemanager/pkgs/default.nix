{
  config,
  pkgs,
  # unstable-pkgs,
  # lib,
  theme-config,
  ...
}: {
  imports =
    map (fname: (import (./. + "/${fname}.nix") {inherit config pkgs theme-config;})) [
      "bat"
      "bash"
      "copyq/copyq"
      # dash-to-panel
      # dolphin
      "dunst"
      "eww/eww"
      "eza"
      "fzf"
      # forge
      "gnome/gnome"
      "git"
      "gpg"
      "hyprland/hyprland"
      "python/python"
      # "sops/sops"
      "starship"
      "sublime-text/sublime-text"
      "superfile/superfile"
      "tilix"
      "vscodium/vscodium"
    ]
    ++ [
      # (import ./bat {inherit pkgs;})
      # (import ./copyq/copyq {inherit pkgs;})
      # (import ./starship {inherit theme-config;})
      # (import ./sublime-text {inherit config pkgs theme-config;})
      # (import ./tilix {inherit config pkgs theme-config;})
    ];
}
