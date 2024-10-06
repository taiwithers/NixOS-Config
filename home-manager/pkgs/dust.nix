{ pkgs, ... }:
{
  home.packages = [ pkgs.dust ];
  home.shellAliases = {
    "du" = "echo 'Consider using dust instead or use \\du to access du.'";
    "dust" = "dust --reverse --ignore-directory mnt";
  };
}
