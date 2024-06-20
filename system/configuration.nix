# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  hostName,
  # flake-inputs,
  ...
}: {
  programs.hyprland.enable = true;
  # xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk]; # add in when switching to hyprland
  # xdg.portal.enable = true;

  imports = [
    ./hardware-configuration.nix
    ./sops/sops.nix
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
    settings.use-xdg-base-directories = true;

    # hyprland
    # settings.substituters = ["https://hyprland.cachix.org"];
    # settings.trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];

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
    hostName = hostName; # hostname defined in flake.nix
    networkmanager.enable = true;
  };

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  services = {
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    libinput.touchpad = {
      tappingButtonMap = "lrm";
      tapping = true;
      disableWhileTyping = true;
      clickMethod = "clickfinger";
    };
    xserver = {
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true; # comment this out to switch to hyprland

      # Configure keymap in X11
      xkb.layout = "us";
      xkb.variant = "";

      excludePackages = [pkgs.xterm];

      # displayManager.sddm.enable = true;
      # displayManager = {
      # autoLogin = {
      #   enable = true;
      #   user = "tai";
      # };
      # sddm = {
      #   enable = true;
      #   wayland.enable = true;
      #   # autoNumlock = true;
      # };
      # };
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

  # enable this when on 24.05
  # systemd.sysusers.enable = true; # create users with systemd-sysusers instead of a perl script

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
    gedit
    gnome.gnome-terminal # always have an editor and terminal!
  ];
  environment.gnome.excludePackages = [pkgs.gnome-tour];

  programs.vim.defaultEditor = true;
  programs.dconf.enable = true;

  environment.pathsToLink = ["/share/zsh"]; # for zsh completion

  # flatpak https://nixos.org/manual/nixos/stable/index.html#module-services-flatpak
  # services.flatpak.enable = true;
  # xdg.portal.config.common.default = "gtk";

  system.autoUpgrade = {
    enable = true;
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
