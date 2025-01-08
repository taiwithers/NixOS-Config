{ pkgs, ... }:
{

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # system packages
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix

    konsole # always have an editor and terminal!
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

    kdePackages.partitionmanager
    kdePackages.ksystemlog

    kdePackages.sddm-kcm # is in colors and themes
    # sddm-kcm # uses version 5.27 which installs qt 5

    (pkgs.where-is-my-sddm-theme.override {
      themeConfig.General = {
        backgroundFill = "#171726";
        basicTextColor = "#878d96";
        showSessionsByDefault = true;
        showUsersByDefault = true;
        hideCursor = true;
      };
    })

    # nvidia monitors
    nvtopPackages.nvidia
    nvitop

  ];

  # Install firefox.
  # programs.firefox.enable = true;

  # steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    extest.enable = true; # allow steam input on wayland?
  };

  # gamemode - requests optimizations when running games
  programs.gamemode.enable = true;
  programs.gamemode.settings = {
    gpu = {
      apply_gpu_optimisations = "accept-responsibility";
      gpu_device = 0;
    };
    custom = {
      start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
      end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
    };
  };
  users.users.tai.extraGroups = [ "gamemode" ];

  # program configurations
  programs.vim.enable = true;
  programs.vim.defaultEditor = true;
  programs.dconf.enable = true;

  xdg.terminal-exec.enable = true;

  programs.kdeconnect.enable = true;
}
