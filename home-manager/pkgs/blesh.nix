{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.blesh];
  programs.bash.bashrcExtra = ''
    source $(blesh-share)/ble.sh
  '';
}
