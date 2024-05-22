{
  config,
  pkgs,
  ...
}: let
  autostart-pkgs = with pkgs; [
    teams-for-linux
    # copyq
    onedrivegui
  ];
in {
  imports = [
    (import ../../nix-scripts/autostart.nix {inherit config autostart-pkgs;})
  ];
}
