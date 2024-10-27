{ ... }:
{
  # boot and dual-boot options
  time.hardwareClockInLocalTime = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # grub
  # boot.loader.grub = {
  #     enable = false;
  #     efiSupport = true;
  #     devices = [ "nodev" ];
  #     useOSProber = true;
  #     configurationLimit = 16;
  # };

  # systemd
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 16;
}
