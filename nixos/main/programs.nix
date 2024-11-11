{ pkgs, ... }:
{
  # unfree software
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "libfprint-2-tod1-goodix" # fingerprint driver
      "steam"
      "steam-original"
      "steam-run"
      "steamcmd"
      "steam-unwrapped"
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced" # no errer requested but hey
    ];

  # system packages
  environment.systemPackages = with pkgs; [
    gnome.gnome-terminal # always have an editor and terminal!
    git
    bluez # bluetooth
    coreutils
    busybox

    # sysinfo for kde
    clinfo
    glxinfo
    gpu-viewer
    vulkan-tools
    wayland-utils

    kdePackages.sddm-kcm # is in colors and themes
    # sddm-kcm # uses version 5.27 which installs qt 5

    (pkgs.where-is-my-sddm-theme.override {
      themeConfig.General = {
        backgroundFill = "#171726";
        basicTextColor = "#878d96";
        showSessionsByDefault = true;
        showUsersByDefault = true;
      };
    })

  ];

  # Install firefox.
  programs.firefox.enable = true;

  # steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    extraCompatPackages = [pkgs.proton-ge-bin];
    extest.enable = true; # allow steam input on wayland?
  };

  # gamemode - requests optimizations when running games
  programs.gamemode.enable = true;

  # program configurations
  #   programs.vim.enable = true;
  programs.vim.defaultEditor = true;
  programs.dconf.enable = true;

  xdg.terminal-exec.enable = true;

  programs.kdeconnect.enable = true;
}
