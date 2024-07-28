{ pkgs, ... }:
{
  home.packages = [ pkgs.dust ];
  home.shellAliases = 
  {"du" = "echo 'Consider using dust instead'";
  "dust" = "dust --reverse --ignore-directory mnt";};
}
