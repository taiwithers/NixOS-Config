{ pkgs, ... }:
{

  # system packages
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix

    git
    coreutils

    duf
    dust

    # if running niri, need terminal emulator and launcher
    rofi
    kitty
  ];

  programs.niri.enable = true;
  services.displayManager.ly = {
    enable = true;
    settings = {
      battery_id = "BAT0"; # show battery status of this battery... can't do both
      # bg = "0x00RRGGBB"; # "0x00RRGGBB" in hex
      bigclock = "en"; # show clock in english, "none" to disable
      # border_fg = "0x00RRGGBB"; # "0x00RRGGBB" in hex
      # fg = "0x00RRGGBB"; # "0x00RRGGBB" in hex
      # box_title = "Hi :)"; # just doesn't look good :(

      clear_password = true; # empty field on failure
      hide_version_string = true;
      session_log = "~/.local/state/ly-session.log"; # default is ".local/state/ly-session.log" which ends up as ~/ly-session.log for some reason
      xinitrc = "null"; # i don't know what this is, but I don't use it

      # deal with nix paths
      # should probably do a PR for the brightness ones, since those directly conflict w/ ly defaults
      brightness_down_cmd = "${pkgs.brightnessctl}/bin/brightnessctl --quiet --min-value set 10%-";
      brightness_up_cmd = "${pkgs.brightnessctl}/bin/brightnessctl --quiet --min-value set +10%";
      sleep_cmd = "null"; # nixos doesn't set a default systemd command like it does for reboot/poweroff
      hibernate_cmd = "null"; # nixos doesn't set a default systemd command like it does for reboot/poweroff, so if hibernate *is* set up, need to set this manually
    };
  };

  services.kanata = {
    enable = true;
    keyboards.default = {
      extraDefCfg = "process-unmapped-keys yes";
      config = builtins.readFile ./kanata.kbd;
    };
  };

  services.upower = {
    enable = true;
    percentageLow = 20;
    percentageCritical = 10;
    percentageAction = 2; # when the critical battery percentage action actually happens
    criticalPowerAction = "HybridSleep"; # default, hibernate not set up yet
  };

  # program configurations
  programs.vim.enable = true;
  programs.vim.defaultEditor = true;
  programs.dconf.enable = true;

  xdg.terminal-exec.enable = true;

  # programs.kdeconnect.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      gfortran.cc.lib
      stdenv.cc.cc
      xorg.libX11
      xorg.libXext
      zlib
    ];
  };
}
