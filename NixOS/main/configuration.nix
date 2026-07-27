{ pkgs, ... }:

{
  imports = [
    ./common.nix
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

  # keep system up to date
  system.autoUpgrade = {
    enable = true;
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
  };

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=0
  '';

  # drivers for new xbox controllers over bluetooth
  # note: you also need to update the firmware on the controller via the
  # windows-only xbox accessories app
  # if the computer says the controller is connected (but doesn't see any input)
  # while the controller is still searching for a connection, this is the problem
  # wired should work fine regardless
  hardware.xpadneo.enable = true;

  networking.hostName = "nixos"; # Define your hostname.

  # limit cpu usage during build
  nix.settings.cores = 4; # cores per job
  nix.settings.max-jobs = 4;

  services.dbus.packages = [ pkgs.dconf ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # TODO: check if disabling this retains xwayland for games
  services.xserver.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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
    nvidia-settings = "nvidia-settings --config=\"$XDG_CONFIG_HOME\"/nvidia/settings";
  };

  documentation.nixos.includeAllModules = true;
  documentation.man.cache.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?

  # graphics
  hardware.graphics.enable = true;
  powerManagement.enable = true;
  services.xserver.videoDrivers = [
    "nvidia"
    "displaylink"
  ]; # Load driver for Xorg and Wayland, set by nixos-hardware
  hardware.nvidia = {
    modesetting.enable = true; # required, set by nixos-hardware
    open = false; # Use the NVidia open source kernel module - false for my gpu
    nvidiaSettings = true; # Enable the Nvidia settings menu, accessible via `nvidia-settings`.

    # prime is the stuff for only using your gpu for certain tasks
    prime.offload = {
      enable = true; # set by nixos-hardware
      enableOffloadCmd = true; # set by nixos-hardware
    };
  };
}
