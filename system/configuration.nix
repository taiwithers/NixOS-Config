# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      devices = ["nodev"];
      useOSProber = true;
      configurationLimit = 16;
      backgroundColor = "#000000";
      # memtest86.enable = true;#
      # fontSize = 16;
    };
  };

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];

    optimise = {
      automatic = true;
      dates = ["weekly"];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  networking = {
    hostName = "nixos"; # Define your hostname.
    networkmanager.enable = true;
  };

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  services = {
    xserver = {
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      # Configure keymap in X11
      layout = "us";
      xkbVariant = "";

      excludePackages = [pkgs.xterm];
    };

    gnome.core-shell.enable = true;
    gnome.core-utilities.enable = false;
    printing.enable = true;
    dbus.packages = [pkgs.dconf];

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tai = {
    isNormalUser = true;
    description = "Tai";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      firefox
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    gnome.gnome-terminal # always have an editor and terminal!
    gnome.gedit
  ];
  environment.gnome.excludePackages = [pkgs.gnome-tour];
  nixpkgs.config.allowUnfree = true;

  programs.dconf.enable = true;

  # flatpak https://nixos.org/manual/nixos/stable/index.html#module-services-flatpak
  services.flatpak.enable = true;
  # xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  xdg.portal.config.common.default = "gtk";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
