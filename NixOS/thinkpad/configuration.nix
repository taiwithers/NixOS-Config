{ pkgs, ... }:
{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./bootloader.nix
    ./programs.nix
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

  networking.hostName = "thinkpad"; # Define your hostname.

  hardware.trackpoint.enable = true; # set by nixos-hardware
  hardware.trackpoint.emulateWheel = true; # set by nixos-hardware
  # other trackpoint options exist and are no defaults are recommended by nh

  # limit cpu usage during build
  # nix.settings.cores = 4; # cores per job
  # nix.settings.max-jobs = 4;

  services.xserver.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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

  system.stateVersion = "24.05"; # Did you read the comment?

  # graphics
  hardware.graphics.enable = true;
  #  powerManagement.enable = true; # nixos-hardware enables services.tlp, not sure how this is/isn't related

}
