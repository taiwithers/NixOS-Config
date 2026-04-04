{ pkgs, ... }:
{

  # system packages
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix

    git
    coreutils

    duf
    dust

    # if running niri, need terminal emulator and launcher
    rofi
    kitty
  ];

  programs.niri.enable = true;

  services.upower = {
    enable = true;
    percentageLow = 20;
    percentageCritical = 10;
    percentageAction = 2; # when the critical battery percentage action actually happens
    criticalPowerAction = "HybridSleep"; # default, hibernate not set up yet
  };

  # program configurations
  programs.vim.enable = true;
  programs.vim.defaultEditor = true;
  programs.dconf.enable = true;

  xdg.terminal-exec.enable = true;

  # programs.kdeconnect.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      gfortran.cc.lib
      stdenv.cc.cc
      xorg.libX11
      xorg.libXext
      zlib
    ];
  };
}
