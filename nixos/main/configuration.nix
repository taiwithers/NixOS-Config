{
  config,
  pkgs,
  hostname,
  # flake-inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];
  # boot and dual-boot options
  time.hardwareClockInLocalTime = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # grub
  # boot.loader.grub = {
  #     enable = false;
  #     efiSupport = true;
  #     devices = [ "nodev" ];
  #     useOSProber = true;
  #     configurationLimit = 16;
  # };

  # systemd
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 16;


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
  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    theme = "where_is_my_sddm_theme";
    # autoLogin.relogin = true;
  };

  services.desktopManager.plasma6.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.displayManager.defaultSession = "plasma";
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    khelpcenter
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
    ];
    packages = with pkgs; [ firefox ];
  };

  # system packages
  environment.systemPackages = with pkgs; [
    gnome.gnome-terminal # always have an editor and terminal!
    git
    bluez # bluetooth
    # sysinfo for kde
    clinfo
    glxinfo
    gpu-viewer
    vulkan-tools
    wayland-utils

    sddm-kcm

    (pkgs.where-is-my-sddm-theme.override {
      themeConfig.General = {
          backgroundFill = "#171726";
          basicTextColor = "#878d96";
          showSessionsByDefault = true;
          showUsersByDefault = true;
        };
    })

    kdePackages.powerdevil # display brightness?
  ];

  # Install firefox.
  programs.firefox.enable = true;

  # graphics 
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ]; # Load "nvidia" driver for Xorg and Wayland
  hardware.nvidia = {
    modesetting.enable = true; # required.

    # Use the NVidia open source kernel module - false for my gpu
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
      "steamcmd"
      "steam-unwrapped"
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced" # no errer requested but hey
    ];

  # steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    package = pkgs.steam.override {
      extraLibraries =
        p: with p; [
          (lib.getLib networkmanager)
        ];
    };
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
  services.printing.drivers = [ pkgs.brlaser ];
  # allow printing without downloading drivers, https://nixos.wiki/wiki/Printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # program configurations
  #   programs.vim.enable = true;
  programs.vim.defaultEditor = true;
  programs.dconf.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
