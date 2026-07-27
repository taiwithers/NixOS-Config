{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  networking.firewall = {
    enable = true;
  };

  nix.package = pkgs.lix;

  # use flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    # "no-url-literals" # quote urls
    # currently broken in Lix
    # https://git.lix.systems/lix-project/lix/issues/1214
  ];

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=0
  '';

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
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" # nix-community.org
  ];

  networking.hostName = "rpi3"; # Define your hostname.
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

  # hardware.bluetooth.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      # PasswordAuthentication = false;
      # KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "tai" ];
      # MaxAuthTries = 3;
      # PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
    };
  };

  # limit cpu usage during build
  nix.settings.cores = 4; # cores per job
  nix.settings.max-jobs = 4;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.dbus.packages = [ pkgs.dconf ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tai = {
    isNormalUser = true;
    description = "Tai";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      git
      duf
      dust
      vim
      wget
      curl
      coreutils
    ];
  };
  programs.vim.enable = true;
  programs.vim.defaultEditor = true;

  nix.settings.trusted-users = [ "@wheel" ];

  environment.shellAliases = {
    rm = "rm --interactive=always --verbose";
  };
  environment.variables = {
    TERM = "xterm";
  };

  documentation.nixos.includeAllModules = true;
  documentation.man.cache.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?

  # graphics
  hardware.graphics.enable = true;
  powerManagement.enable = true;
  environment.pathsToLink = [ "/share/bash-completion" ]; # bash completion for system packages
  documentation.nixos.options.warningsAreErrors = false;
}
