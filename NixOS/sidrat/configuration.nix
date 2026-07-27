{ pkgs, lib, ... }:
{

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  users.users.tai.extraGroups = [ "docker" ];

  imports = [ ../common.nix ];

  security.sudo.extraConfig = ''
    Defaults pwfeedback
    Defaults timestamp_timeout=0
  '';

  networking.hostName = "nixos"; # Define your hostname.

  # limit cpu usage during build
  nix.settings.cores = 4; # cores per job
  nix.settings.max-jobs = 4;

  networking.wireless.enable = lib.mkForce false; # nixos-wsl defined true was killing rebuild - possibly due to missing file in /etc/

  services.dbus.packages = [ pkgs.dconf ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  services.hardware.bolt.enable = true; # handle thunderbolt devices

  fonts.enableDefaultPackages = true;

  system.stateVersion = "24.05"; # Did you read the comment?

  hardware.graphics.enable = true;
}
