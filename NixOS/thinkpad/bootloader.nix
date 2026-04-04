{
  pkgs,
  ...
}:
{
  # boot and dual-boot options
  time.hardwareClockInLocalTime = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # uuid found by combo of lsblk and ls /dev/disk/by-uuid
  # regardless of what I put in "chainloader" it doesn't seem to work lol
  # boot.loader.grub.extraEntries = ''
  #   menuentry "Fedora Atomic (Kinoite)" {
  #     search --set=root --fs-uuid 1a74e667-354f-4793-84f5-5350ed52c424
  #     chainloader /boot/EFI/fedora/grubx64.efi
  #   }
  # '';

  # grub
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    useOSProber = true;
    configurationLimit = 16;

    font = "${pkgs.nerd-fonts.space-mono}/share/fonts/truetype/NerdFonts/SpaceMono/SpaceMonoNerdFontPropo-Regular.ttf";
    fontSize = 24;

    splashImage = ./background.png;
    splashMode = "normal";
  };
}
