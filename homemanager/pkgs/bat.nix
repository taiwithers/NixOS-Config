{
  config,
  pkgs,
  ...
}: {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      # batdiff
      # batgrep
      batman
      # batpipe
    ];

    config = {
      theme = "base16";
    };
  };
}
