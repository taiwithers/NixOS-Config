{
  config,
  pkgs,
  hostname,
  flake-inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    (import ./bootloader.nix { inherit pkgs; })
    ./desktopenvironments.nix
    ./programs.nix
  ];

  nixpkgs.overlays = [
    (self: super: {
      unstable = import flake-inputs.nixpkgs-unstable {
        system = builtins.currentSystem;
        config = config.nixpkgs.config;
      };
    })
  ];

  # use lix
  nix.package = pkgs.lix;

  # use flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "no-url-literals" # quote urls
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
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # limit cpu usage during build
  nix.settings.cores = 4; # cores per job
  nix.settings.max-jobs = 4; 

  # touchpad
  # services.libinput.enable = true; # enabled by default for most desktopManagers

  services.dbus.packages = [ pkgs.dconf ];
  services.xserver.enable = true; # can disable if only using Wayland

  # keyboard layout
  services.xserver.xkb.layout = "us";

  # sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true; # sound card drivers
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # user account
  users.users.tai = {
    isNormalUser = true;
    description = "Tai";
    extraGroups = [
      "networkmanager" # allow modifying network settings
      "wheel" # allow using sudo
    ];
    packages = with pkgs; [ ];
  };
  nix.settings.trusted-users = [ "@wheel" ];

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

  # fingerprint reader
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  powerManagement.enable = true;

  services.hardware.bolt.enable = true; # handle thunderbolt devices

  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.brlaser
    pkgs.hplip
  ];
  # allow printing without downloading drivers, https://nixos.wiki/wiki/Printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  
  fonts.enableDefaultPackages = true;

  documentation.nixos.includeAllModules = true;
  documentation.man.generateCaches = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
