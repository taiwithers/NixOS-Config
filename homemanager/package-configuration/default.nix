{
  config,
  pkgs,
  unstable-pkgs,
  lib,
  selectAvailableTheme,
  ...
}: {
  imports =
    map (fname: ./. + "/${fname}" + ".nix") [
      "bash"
      "bat"
      # dash-to-panel
      # dolphin
      "eza"
      # forge
      "git"
      "gpg"
      "vscodium"
    ]
    ++ [
      (import ./copyq.nix {inherit unstable-pkgs;})
      (import ./sublime-text.nix {inherit config pkgs selectAvailableTheme;})
      (import ./tilix.nix {inherit config pkgs selectAvailableTheme;})
    ];
}
