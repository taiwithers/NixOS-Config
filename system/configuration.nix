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
  imports = [
    ./hardware-configuration.nix
    ./sops/sops.nix
  ];

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
    };
  };

  # use flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # clean up $HOME (moves ~/.nix-* to $XDG_STATE_HOME/nix/*)
  nix.settings.use-xdg-base-directories = true;

  # keep system up to date
  system.autoUpgrade = {
    enable = true;
    flags = ["--update-input" "nixpkgs" "--commit-lock-file"];
  };

  # keep system clean :)
  nix.optimise = {
    automatic = true;
    dates = ["weekly"];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;

  networking.hostName = hostName;

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  # touchpad
  # services.libinput.enable = true; # enabled by default for most desktopManagers

  # GNOME
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];
  services.dbus.packages = [pkgs.dconf];
  environment.gnome.excludePackages = [pkgs.gnome-tour];
  services.gnome.core-utilities.enable = false;

  # KDE
  # services.xserver.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.displayManager.defaultSession = "plasma";
  # environment.plasma6.excludePackages = [];

  # keyboard layout
  services.xserver.xkb.layout = "us";

  # sound
  sound.enable = true;
  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  # };

  # user account
  users.users.tai = {
    isNormalUser = true;
    description = "Tai";
    extraGroups = [
      "wheel"
      "input" # input for waybar on hyprland
      "video" # for backlight control with light
    ];
    packages = with pkgs; [
      firefox
    ];
  };

  # system packages
  environment.systemPackages = with pkgs; [
    gedit
    gnome.gnome-terminal # always have an editor and terminal!
    git
  ];

  # program configurations
  programs.vim.defaultEditor = true;
  programs.dconf.enable = true;
  environment.pathsToLink = ["/share/zsh"]; # for zsh completion
  programs.hyprland.enable = true;
  # xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gdk]; # add in when switching to hyprland
  programs.light.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
