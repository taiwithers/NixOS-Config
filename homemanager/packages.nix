{
  pkgs,
  lib,
  unstable-pkgs,
  ...
}: let
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
  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "dell-command-configure"
        "discord"
        "obsidian"
        "realvnc-vnc-viewer"
        "slack"
        "sublimetext4"
        "vivaldi"
        "zoom"
      ];
    permittedInsecurePackages = [
      "electron-25.9.0"
      "openssl-1.1.1w"
    ];
  };

  services.flatpak = {
    remotes = [
      {
        name = "starlink";
        location = "https://ftp.eao.hawaii.edu/starlink/flatpak/starlink.flatpakrepo";
      }
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
      "edu.hawaii.eao.starlink.Starlink"
    ];
  };

  home.packages = with pkgs; [
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello'
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    alejandra
    nix-prefetch-scripts
    nurl
    # appimage-run
    nix-diff
    nix-tree
    nix-search-cli # provides nix-search
    unstable-pkgs.deadnix
    dconf2nix
    unstable-pkgs.nix-output-monitor # sudo nixos-rebuild [usual options] |& nom

    bash
    bat
    # bat-extras.batman
    btop
    curl
    dconf
    eza
    fd
    fzf
    gfortran
    git
    jq
    lazygit
    oh-my-zsh
    openssh
    pandoc
    parallel
    pomodoro
    python3
    rename
    ripgrep
    speedtest-rs
    trashy
    unzip
    vim
    wget
    xdg-ninja
    zip
    zsh

    dell-command-configure
    discord
    filezilla
    fontconfig
    github-desktop
    gnome.gnome-screenshot
    gnome.gnome-tweaks
    gnome-extension-manager
    gparted
    keepassxc
    libreoffice
    libsForQt5.dolphin
    obsidian
    onedrive
    onedrivegui
    realvnc-vnc-viewer
    slack-dark
    teams-for-linux
    tilix
    zoom-us
    vscodium-fhs

    unstable-pkgs.copyq
    unstable-pkgs.fastfetch
    unstable-pkgs.sublime4
    unstable-pkgs.zotero_7
    unstable-pkgs.vivaldi

    texlive-pkgs
  ];
}
