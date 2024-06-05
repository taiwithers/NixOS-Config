{
  config,
  pkgs,
  theme-config,
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

  # xdg.configFile."${xdg.configHome}/bat/themes/base16.tmTheme" = {
  #   onChange = "bat cache --build"; # bat --list-themes to check if new theme has been made available
  #   text = '' '';
  # };
}
