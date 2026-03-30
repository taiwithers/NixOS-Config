{ pkgs, ... }:
{
  home.packages = [ pkgs.duf ];
  home.shellAliases."duf" = "duf -only local";
}
