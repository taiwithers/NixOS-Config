{ pkgs, ... }: {
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  users.users.tai.packages = with pkgs; [
    git
    duf
    dust
    wget
    curl
    coreutils
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  networking.firewall = {
    enable = true;
  };

  networking.hostName = "rpi3"; # Define your hostname.

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      AllowUsers = [ "tai" ];
    };
  };

  # limit cpu usage during build
  nix.settings.cores = 4; # cores per job
  nix.settings.max-jobs = 2;

  environment.variables = {
    TERM = "xterm";
  };

  system.stateVersion = "26.05"; # Did you read the comment?
}
