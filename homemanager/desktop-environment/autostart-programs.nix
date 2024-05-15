{
  config,
  pkgs,
  ...
}: let
  autostart-pkgs = with pkgs; [
    teams-for-linux
    # unstable-pkgs.copyq
    copyq
    onedrivegui
  ];
in {
  imports = [
    (import ../../nix-scripts/autostart.nix {inherit config autostart-pkgs;})
  ];
}
