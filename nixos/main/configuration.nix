# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  hostname,
  # flake-inputs,
  ...
}: {
  imports = [
    ./hardware.nix
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
    dates = ["weekly"];
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

  services.dbus.packages = [pkgs.dconf];
  services.xserver.enable = true;
  
  # GNOME
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];
  environment.gnome.excludePackages = [pkgs.gnome-tour];
  services.gnome.core-utilities.enable = false;

  # KDE
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
      "networkmanager" # allow modifying network settings
      "wheel"
      "ld" # for bluetooth? maybe?
      "input" # input for waybar on hyprland
    ];
    packages = with pkgs; [firefox];
  };

  # system packages
  environment.systemPackages = with pkgs; [
    gedit
    gnome.gnome-terminal # always have an editor and terminal!
    git
  ];

  services.printing.enable = true;
  # allow printing without downloading drivers, https://nixos.wiki/wiki/Printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # program configurations
  # programs.vim.enable = true;
  programs.vim.defaultEditor = true;
  programs.dconf.enable = true;
  environment.pathsToLink = ["/share/zsh"]; # for zsh completion
  programs.hyprland.enable = true;
  # xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gdk]; # add in when switching to hyprland

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
