{ pkgs, ... }:
{
  home.packages = [ pkgs.ripgrep ];
  home.shellAliases = {
    "grep" = "echo 'Consider using ripgrep [rg] or batgrep instead'";
    "rg" = "rg --hyperlink-format=default";
  };
}
