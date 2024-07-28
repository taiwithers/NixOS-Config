{ pkgs, ... }:
{
  home.packages = [ pkgs.duf ];
  home.shellAliases."df" = "echo 'Consider using duf instead'";
}
