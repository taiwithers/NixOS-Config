{
  config,
  pkgs,
  # unstable-pkgs,
  # lib,
  app-themes,
  ...
}: {
  imports =
    map (fname: (import (./. + "/${fname}.nix") {inherit config pkgs app-themes;})) [
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
      "git"
      "gnome/gnome"
      "gpg"
      # "hyprland/hyprland"
      "neovim"
      "python/python"
      "starship/starship"
      "sublime-text/sublime-text"
      "superfile/superfile"
      # "superfile/superfile-theme"
      "tilix"
      "vscodium/vscodium"
      "zsh"
    ]
    ++ [
    ];
}
