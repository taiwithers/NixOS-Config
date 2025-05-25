{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./desktopenvironments.nix
    ./programs.nix
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 35413 ];
    allowedUDPPorts = [ 35413 ];
  };

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

  # use community cache
  nix.settings.substituters = map (name: "https://${name}.cachix.org") [ "nix-community" ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
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

  hardware.bluetooth.enable = true;

  # limit cpu usage during build
  nix.settings.cores = 4; # cores per job
  nix.settings.max-jobs = 4;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.dbus.packages = [ pkgs.dconf ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tai = {
    isNormalUser = true;
    description = "Tai";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
    ];
  };

  nix.settings.trusted-users = [ "@wheel" ];

  # fingerprint reader
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  services.hardware.bolt.enable = true; # handle thunderbolt devices

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.brlaser
    pkgs.hplip
  ];
  # allow printing without downloading drivers, https://nixos.wiki/wiki/Printing
  # services.avahi = {
  #   enable = true;
  #   nssmdns4 = true;
  #   openFirewall = true;
  # };

  fonts.enableDefaultPackages = true;

  environment.shellAliases = {
    rm = "rm --interactive=always --verbose";
    nvidia-settings = "nvidia-settings --config=\"$XDG_CONFIG_HOME\"/nvidia/settings";
  };

  documentation.nixos.includeAllModules = true;
  documentation.man.generateCaches = true;

  system.stateVersion = "24.05"; # Did you read the comment?

  # graphics
  hardware.graphics.enable = true;
  powerManagement.enable = true;
  services.xserver.videoDrivers = [ "nvidia" "displaylink"]; # Load driver for Xorg and Wayland, set by nixos-hardware
  hardware.nvidia = {
    modesetting.enable = true; # required, set by nixos-hardware

    # Use the NVidia open source kernel module - false for my gpu
    open = false;

    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # # package = config.boot.kernelPackages.nvidiaPackages.stable;

    # prime is the stuff for only using your gpu for certain tasks
    prime.offload = {
      enable = true; # set by nixos-hardware
      enableOffloadCmd = true; # set by nixos-hardware
    };
  };
  environment.pathsToLink = [ "/share/bash-completion" ]; # bash completion for system packages
  documentation.nixos.options.warningsAreErrors = false;
}
