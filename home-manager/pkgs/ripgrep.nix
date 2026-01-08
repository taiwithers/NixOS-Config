{ pkgs, ... }:
{
  home.packages = [ pkgs.ripgrep ];
  home.shellAliases = {
    "rg" = "rg --hyperlink-format=default --ignore-case";
  };
}
