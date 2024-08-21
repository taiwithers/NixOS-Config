{pkgs, ...}: {
  home.packages = [pkgs.duf];
  home.shellAliases."df" = "echo 'Consider using duf instead, or use \\df to access df.'";
}
