{pkgs, ...}: {
  programs.bat.extraPackages = with pkgs.bat-extras; [
    # batdiff
    # batgrep
    batman
    # batpipe
  ];
}
