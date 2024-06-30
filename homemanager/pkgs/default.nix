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
      "bottom"
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
      "lazygit"
      # "hyprland/hyprland"
      "neovim"
      "python/python"
      "starship"
      "sublime-text/sublime-text"
      "superfile"
      "tilix"
      "vscodium/vscodium"
      "zsh"
    ]
    ++ [
    ];
}
