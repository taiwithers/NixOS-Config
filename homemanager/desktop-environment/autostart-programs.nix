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
    (import ../../scripts/autostart.nix {inherit config autostart-pkgs;})
  ];
}
