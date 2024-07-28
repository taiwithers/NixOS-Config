{ pkgs, ... }:
{
  programs.bash.bashrcExtra = "source <( ${pkgs.cod}/bin/cod init $$ bash)";
  home.packages = [ pkgs.cod ];
}
