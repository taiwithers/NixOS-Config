{
  pkgs,
  lib,
  pkgs-config,
  # unstable,
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
    remotes = {
      "starlink" = "https://ftp.eao.hawaii.edu/starlink/flatpak/starlink.flatpakrepo";
    };
    packages = [
      "starlink:app/edu.hawaii.eao.starlink.Starlink//2023A"
    ];
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
    unstable.deadnix
    dconf2nix
    unstable.nix-output-monitor # sudo nixos-rebuild [usual options] |& nom

    bash
    bat
    btop
    conda
    curl
    unstable.cloc
    dconf
    duf
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
    # python3
    rename
    ripgrep
    sd
    speedtest-rs
    trashy
    unzip
    vim
    wget
    xdg-ninja
    zip
    zsh
    unstable.zoxide

    dell-command-configure
    discord
    filezilla
    fontconfig
    github-desktop
    gnome.gnome-screenshot
    gnome.gnome-tweaks
    gnome.file-roller
    gnome-extension-manager
    gparted
    keepassxc
    libreoffice
    libsForQt5.dolphin
    loupe # gnome imager viewer
    unstable.obsidian
    onedrive
    onedrivegui
    realvnc-vnc-viewer
    slack-dark
    teams-for-linux
    tilix
    zoom-us
    vscodium-fhs

    unstable.copyq
    unstable.fastfetch
    unstable.sublime4
    unstable.zotero_7
    unstable.vivaldi

    texlive-pkgs

    # hyprland extras
    swaybg
    eww-wayland
    # unstable.eww
    # unstable.dunst
    xdg-desktop-portal-hyprland
    # xdg-desktop-portal-gtk # in configuration.nix
    # libsForQt5.qt5.wayland
    # qt6.qtwayland
    kitty # hyprland default
    unstable.rofi-wayland

    (unstable.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    )

  ];
}
