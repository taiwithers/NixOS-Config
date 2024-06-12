{
  config,
  pkgs,
  # unstable-pkgs,
  # lib,
  theme-config,
  ...
}: {
  imports =
    map (fname: (import (./. + "/${fname}") {inherit config pkgs theme-config;})) [
      "bat.nix"
      "bash.nix"
      "copyq/copyq.nix"
      # dash-to-panel
      # dolphin
      "dunst.nix"
      # "eww"
      "eza.nix"
      "fzf.nix"
      # forge
      "gnome"
      "git.nix"
      "gpg.nix"
      "hyprland/hyprland.nix"
      "python/python.nix"
      # "sops/sops.nix"
      "starship.nix"
      "sublime-text/sublime-text.nix"
      "tilix.nix"
      "vscodium/vscodium.nix"
    ]
    ++ [
      # (import ./bat.nix {inherit pkgs;})
      # (import ./copyq/copyq.nix {inherit pkgs;})
      # (import ./starship.nix {inherit theme-config;})
      # (import ./sublime-text {inherit config pkgs theme-config;})
      # (import ./tilix.nix {inherit config pkgs theme-config;})
    ];
}
