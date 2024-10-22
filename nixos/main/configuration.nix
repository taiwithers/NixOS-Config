# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  hostname,
  # flake-inputs,
  ...
}:
{
  imports = [
    ./hardware.nix
  ];
  # boot and dual-boot options
  time.hardwareClockInLocalTime = true;
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/EFI";
    };
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
      useOSProber = true;
      configurationLimit = 16;
      backgroundColor = "#000000";
    };
  };

  # use flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # keep system up to date
  system.autoUpgrade = {
    enable = true;
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
  };

  # keep system clean :)
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;
  # clean up $HOME (moves ~/.nix-* to $XDG_STATE_HOME/nix/*)
  nix.settings.use-xdg-base-directories = true;

  # networking
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";
  hardware.bluetooth.enable = true;

  # touchpad
  # services.libinput.enable = true; # enabled by default for most desktopManagers

  services.dbus.packages = [ pkgs.dconf ];
  services.xserver.enable = true;

  # GNOME
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  # environment.gnome.excludePackages = [pkgs.gnome-tour];
  # services.gnome.core-utilities.enable = false;

  # KDE
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.displayManager.defaultSession = "plasma";
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    gwenview
    kate
    khelpcenter
    kinfocenter
    konsole
    kwalletmanager
    okular
  ];

  # keyboard layout
  services.xserver.xkb.layout = "us";

  # sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # user account
  users.users.tai = {
    isNormalUser = true;
    description = "Tai";
    extraGroups = [
      "networkmanager" # allow modifying network settings
      "wheel"
      "ld" # for bluetooth? maybe?
      "input" # input for waybar on hyprland
    ];
    packages = with pkgs; [ firefox ];
  };

  # system packages
  environment.systemPackages = with pkgs; [
    gedit
    gnome-terminal # always have an editor and terminal!
    git

    # sysinfo for kde
    clinfo
    glxinfo
    gpu-viewer
    vulkan-tools
    wayland-utils
  ];

  # graphics 
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];# Load "nvidia" driver for Xorg and Wayland
  hardware.nvidia = {
    modesetting.enable = true;# Modesetting is required.

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently "beta quality", so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.stable;

    # prime is the stuff for only using your gpu for certain tasks
    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };

  # unfree software
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "libfprint-2-tod1-goodix" # fingerprint driver
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced" # no erreor requested but hey
    ];

  # steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

# gamemode - requests optimizations when running games
programs.gamemode.enable = true;

# fingerprint reader
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  services.printing.enable = true;
  services.printing.drivers = [pkgs.brlaser];
  # allow printing without downloading drivers, https://nixos.wiki/wiki/Printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # program configurations
  programs.vim.enable = true;
  programs.vim.defaultEditor = true;
  programs.dconf.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
