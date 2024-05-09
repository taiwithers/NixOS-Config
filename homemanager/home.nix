{
  config,
  pkgs,
  lib,
  inputs,
  user,
  system,
  ...
}: let
  unstable-pkgs =
    import (builtins.fetchTarball {
      url = "github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz";
      sha256 = "1506hd482n7qb55niqjx4789swjrqyng21xvzfwagq1nr173kd88";
    }) {
      config = config.nixpkgs.config;
      system = system;
    };

  autostart-pkgs = [
    pkgs.teams-for-linux
    unstable-pkgs.copyq
    pkgs.onedrivegui
  ];

  texlive-pkgs = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-small
      derivative
      enumitem
      latexmk
      psnfss # postscript fonts
      hyphenat
      revtex4-1 # for aastex
      siunitx
      standalone
      epsf # for graphics
      svn-prov # required macros
      astro
      ;
  };
in {
  imports = [
    inputs.nix-colors.homeManagerModules.default # inputs is an input to this function
  ];
  home.username = user;
  home.homeDirectory = "/home/${user}";

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "dell-command-configure"
        "discord"
        "obsidian"
        "realvnc-vnc-viewer"
        "slack"
        "sublimetext4"
        "zoom"
      ];
    permittedInsecurePackages = [
      "electron-25.9.0"
      "openssl-1.1.1w"
    ];
  };

  home.packages = with pkgs; [
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello'
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    alejandra
    nix-prefetch-scripts
    nurl 
    # appimage-run

    bash
    bat
    btop
    curl
    dconf
    eza
    fd
    fzf
    git
    jq
    lazygit
    rename
    ripgrep
    speedtest-rs
    trashy
    unzip
    wget
    xdg-ninja
    zip
    zsh
    oh-my-zsh
    gfortran
    openssh
    pandoc
    parallel
    pomodoro
    python3

    dell-command-configure
    discord
    filezilla
    github-desktop
    gparted
    keepassxc
    libsForQt5.dolphin
    obsidian
    onedrive
    onedrivegui
    realvnc-vnc-viewer
    teams-for-linux
    tilix
    zoom-us
    gnome.gnome-tweaks
    libreoffice
    slack-dark
    gnome.gnome-screenshot

    unstable-pkgs.copyq
    unstable-pkgs.fastfetch
    unstable-pkgs.sublime4
    unstable-pkgs.zotero_7

    cm_unicode
    intel-one-mono
    (nerdfonts.override {fonts = ["SpaceMono"];})

    gnomeExtensions.all-windows
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.appindicator
    gnomeExtensions.click-to-close-overview
    gnomeExtensions.desktop-icons-ng-ding
    gnomeExtensions.dash-to-panel
    gnomeExtensions.favourites-in-appgrid
    gnomeExtensions.forge
    # gnomeExtensions.gtile
    gnomeExtensions.start-overlay-in-application-view
    gnomeExtensions.steal-my-focus-window

    texlive-pkgs
  ];

  programs.git = {
    enable = true;
    signing.key = "/home/${user}/.ssh/id_ed25519_github.pub";
    signing.signByDefault = true;
    userEmail = "59430904+taiwithers@users.noreply.github.com";
    userName = "taiwithers";
    extraConfig = {
      gpg.format = "ssh";
      pull.rebase = "false";
      init.defaultBranch = "main";
    };
    delta = {
      enable = true;
      options = {
        dark = true;
        side-by-side = true;
      };
    };
  };

  services.copyq = {
    enable = true;
    package = unstable-pkgs.copyq;
  };

  home.file = builtins.listToAttrs (map (pkg: {
      name = ".config/autostart/${pkg.pname}.desktop";
      value =
        if pkg ? desktopItem
        then {text = pkg.desktopItem.text;}
        else {source = "${pkg}/share/applications/${pkg.pname}.desktop";};
    })
    autostart-pkgs);
}
