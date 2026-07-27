{ pkgs, lib, ... }:
rec {
  #--------------------------------------------------------------------#
  #                            Nix Settings                            #
  #--------------------------------------------------------------------#

  nix.package = pkgs.lix;

  # use flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    (lib.mkIf (lib.versionAtLeast nix.package.version "2.94.3") (
      (lib.warn "Remove no-url-literals guard!") "no-url-literals"
    ))
  ];

  # keep system clean :)
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;

  # use community cache
  nix.settings.substituters = map (name: "https://${name}.cachix.org") [ "nix-community" ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" # nix-community.org
  ];

  documentation.nixos.options.warningsAreErrors = false;

  #--------------------------------------------------------------------#
  #                           User Settings                            #
  #--------------------------------------------------------------------#

  users.users.tai = {
    isNormalUser = true;
    description = "Tai";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = [ ];
  };

  nix.settings.trusted-users = [ "@wheel" ];

  #--------------------------------------------------------------------#
  #                              Packages                              #
  #--------------------------------------------------------------------#

  # force upgrade kernel (copyfail)
  # https://github.com/theori-io/copy-fail-CVE-2026-31431/issues/48#issuecomment-4352886628
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.18.22") (
    lib.mkDefault pkgs.linuxPackages_6_18
  );

  environment.systemPackages = with pkgs; [
    coreutils
    curl
    duf
    dust
    git
    man-pages
    man-pages-posix
    neovim
    wget
  ];

  networking.networkmanager.enable = true;

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      gfortran.cc.lib
      stdenv.cc.cc
      libX11
      libXext
      zlib
    ];
  };

  #--------------------------------------------------------------------#
  #                         Shell/Environment                          #
  #--------------------------------------------------------------------#

  environment.pathsToLink = [ "/share/bash-completion" ]; # bash completion for system packages

  # clean up $HOME (moves ~/.nix-* to $XDG_STATE_HOME/nix/*)
  nix.settings.use-xdg-base-directories = true;

  environment.shellAliases = {
    rm = "rm --interactive=always --verbose";
  };

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=0
  '';

  #--------------------------------------------------------------------#
  #                               Locale                               #
  #--------------------------------------------------------------------#

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}
