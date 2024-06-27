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
      "bottom/bottom"
      "copyq/copyq"
      # dash-to-panel
      # dolphin
      "dunst"
      "eww/eww"
      "eza"
      # forge
      "fzf"
      "gaia"
      "common-git"
      "gnome/gnome"
      "gpg"
      # "hyprland/hyprland"
      "python/python"
      # "sops/sops"
      "starship/starship"
      "sublime-text/sublime-text"
      "superfile/superfile"
      "superfile/superfile-theme"
      "tilix"
      "vscodium/vscodium"
      "zsh"
    ]
    ++ [
      # (import ./bat {inherit pkgs;})
      # (import ./copyq/copyq {inherit pkgs;})
      # (import ./starship {inherit theme-config;})
      # (import ./sublime-text {inherit config pkgs theme-config;})
      # (import ./tilix {inherit config pkgs theme-config;})
    ];
}
