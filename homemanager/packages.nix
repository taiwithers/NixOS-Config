{
  pkgs,
  lib,
  pkgs-config,
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
  nixpkgs.config = pkgs-config;

  services.flatpak = {
    enableModule = true;
    remotes = {"starlink" = "https://ftp.eao.hawaii.edu/starlink/flatpak/starlink.flatpakrepo";};
    packages = ["starlink:app/edu.hawaii.eao.starlink.Starlink//2023A"];
  };
  # services.flatpak = {
  #   # remotes = [
  #   #   {
  #   #     name = "starlink";
  #   #     location = "https://ftp.eao.hawaii.edu/starlink/flatpak/starlink.flatpakrepo";
  #   #   }
  #   #   # {
  #   #   #   name = "flathub";
  #   #   #   location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
  #   #   # }
  #   # ];
  #   packages = [
  #     # {
  #     #   appId = "edu.hawaii.eao.starlink.Starlink";
  #     #   origin = "starlink";
  #     # }
  #     "org.inkscape.Inkscape"
  #   ];
  # };

  home.packages = with pkgs; [
    # nix programs
    # appimage-run
    alejandra
    dconf2nix
    deadnix
    nix-diff
    nix-output-monitor # sudo nixos-rebuild [usual options] |& nom
    nix-prefetch-scripts
    nix-search-cli # provides nix-search
    nix-tree
    nurl

    # cli programs
    bash
    bat
    blesh
    btop
    cloc
    conda
    curl
    dconf
    dell-command-configure
    duf
    eza
    fastfetch
    fd
    fontconfig
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
    sd
    speedtest-rs
    starship
    sxiv
    trashy
    unzip
    vim
    wget
    xdg-ninja
    zip
    zoxide
    zsh

    # gui programs
    # copyq # "installed" via services in copyq.nix
    discord
    filezilla
    github-desktop
    gnome-extension-manager
    gnome.file-roller
    gnome.gnome-screenshot
    gnome.gnome-tweaks
    gparted
    keepassxc
    libreoffice
    libsForQt5.dolphin
    loupe # gnome imager viewer
    obsidian
    onedrive
    onedrivegui
    realvnc-vnc-viewer
    slack-dark
    sublime4
    teams-for-linux
    tilix
    vivaldi
    vscodium-fhs
    zoom-us
    zotero_7

    texlive-pkgs

    # hyprland extras
    # libsForQt5.qt5.wayland
    # qt6.qtwayland
    # rofi-calc
    # unstable.dunst
    # xdg-desktop-portal-gtk # in configuration.nix
    eww # eww-wayland is not necessary
    kitty # hyprland default
    rofi-wayland
    swaybg
    xdg-desktop-portal-hyprland

    (
      waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      })
    )
  ];
}
