{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      # batdiff
      batgrep
      batman
      # batpipe
    ];

    config = {
      theme = "base16";
    };
  };
  home.shellAliases= {
    "man" = "batman --no-hyphenation --no-justification";
    "cat" = "bat";
  };
}
