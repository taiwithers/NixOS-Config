{ pkgs, ... }:
{
  programs.bash.bashrcExtra = "source <( $(which cod) init $$ bash)";
  home.packages = [ pkgs.cod ];
}
