{ pkgs, ... }:
{
  home.packages = [ pkgs.dust ];
  home.shellAliases = {
    "dust" = "dust --reverse --ignore-directory mnt";
  };
}
