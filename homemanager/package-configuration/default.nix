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
      "starship"
      "vscodium"
    ]
    ++ [
      (import ./copyq.nix {inherit pkgs;})
      (import ./copyq.nix {inherit pkgs;})
      (import ./sublime-text.nix {inherit config pkgs theme-config;})
      (import ./tilix.nix {inherit config pkgs theme-config;})
    ];
}
