{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./programs.nix
  ];

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

  # tty settings?
  console = {
    enable = true; # true by default
    packages = with pkgs; [ terminus_font ];
    colors = [ ]; # hexless hash
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
  };

  security.sudo.extraConfig = ''
    Defaults pwfeedback
    Defaults timestamp_timeout=0
  '';

  # clean up $HOME (moves ~/.nix-* to $XDG_STATE_HOME/nix/*)
  nix.settings.use-xdg-base-directories = true;

  # use community cache
  nix.settings.substituters = map (name: "https://${name}.cachix.org") [ "nix-community" ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" # nix-community.org
  ];

  networking.hostName = "thinkpad"; # Define your hostname.
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

  hardware.trackpoint.enable = true; # set by nixos-hardware
  hardware.trackpoint.emulateWheel = true; # set by nixos-hardware
  # other trackpoint options exist and are no defaults are recommended by nh

  # limit cpu usage during build
  # nix.settings.cores = 4; # cores per job
  # nix.settings.max-jobs = 4;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  #  services.dbus.packages = [ pkgs.dconf ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

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
    # description = "Tai";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    # packages = with pkgs; [ ];
  };

  nix.settings.trusted-users = [ "@wheel" ];

  # fingerprint reader - `fprintd-enroll`
  # can't seem to get this working - usbutils' `lsusb` doesn't list a fingerprint reader
  services.fprintd = {
    enable = false;
    # tod = {
    #   enable = true;
    #   driver = pkgs.libfprint-2-tod1-goodix;
    # };
  };

  # services.hardware.bolt.enable = true; # handle thunderbolt devices

  # fonts.enableDefaultPackages = true;

  environment.shellAliases = {
    rm = "rm --interactive=always --verbose";
  };

  system.stateVersion = "24.05"; # Did you read the comment?

  # graphics
  hardware.graphics.enable = true;
  #  powerManagement.enable = true; # nixos-hardware enables services.tlp, not sure how this is/isn't related

  environment.pathsToLink = [ "/share/bash-completion" ]; # bash completion for system packages
  documentation.nixos.options.warningsAreErrors = false;
}
