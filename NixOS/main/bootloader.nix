{
  pkgs,
  ...
}:
{
  # boot and dual-boot options
  time.hardwareClockInLocalTime = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # grub
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    useOSProber = true;
    configurationLimit = 16;

    font = ''${pkgs.nerd-fonts.space-mono}/share/fonts/truetype/NerdFonts/SpaceMono/SpaceMonoNerdFontPropo-Regular.ttf'';
    fontSize = 24;

    splashImage = ./background.png;
    splashMode = "normal";
  };

  # systemd
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.systemd-boot.configurationLimit = 16;
}
