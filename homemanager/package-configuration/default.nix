{
  config,
  pkgs,
  # unstable-pkgs,
  # lib,
  theme-config,
  ...
}: {
  imports =
    map (fname: ./. + "/${fname}" + ".nix") [
      "bash"
      "bat"
      # dash-to-panel
      # dolphin
      "dunst"
      "eza"
      # forge
      "git"
      "gpg"
      "vscodium"
    ]
    ++ [
      (import ./copyq.nix {inherit pkgs;})
      (import ./starship.nix {inherit theme-config;})
      (import ./sublime-text.nix {inherit config pkgs theme-config;})
      (import ./tilix.nix {inherit config pkgs theme-config;})
    ];
}
