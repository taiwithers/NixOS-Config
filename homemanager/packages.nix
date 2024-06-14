{
  pkgs,
  pkgs-config,
  flake-inputs,
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

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     dconf2nix = prev.dconf2nix.overrideAttrs (old: {
  #       src = prev.fetchFromGitHub {
  #         owner = "nix-community";
  #         repo = "dconf2nix";
  #         rev = "63c7eab";
  #         hash = "sha256-kjxRPIPfkX+nzGNaJdEpwmxOeWmfz9ArXNGrCtMs+EI=";
  #         fetchSubmodules = true;
  #       };
  #       libraryHaskellDepends = (old.libraryHaskellDepends or []) ++ [pkgs.haskellPackages.utf8-string];
  #       testHaskellDepends = (old.testHaskellDepends or []) ++ [pkgs.haskellPackages.utf8-string];
  #       executableHaskellDepends = (old.executableHaskellDepends or []) ++ [pkgs.haskellPackages.utf8-string];
  #     });
  #   })
  # ];

  services.flatpak = {
    enableModule = true;
    remotes = {"starlink" = "https://ftp.eao.hawaii.edu/starlink/flatpak/starlink.flatpakrepo";};
    packages = ["starlink:app/edu.hawaii.eao.starlink.Starlink//2023A"];
  };

  home.packages = with pkgs; [
    # nix programs
    appimage-run
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
    age # encryption
    bash
    bat
    # blesh
    btop
    cloc
    # conda
    curl
    dconf
    dell-command-configure
    # dotnet-runtime_7 # for gcm
    duf # view general info for entire system
    dust # view specific info for directories
    eza
    fastfetch
    fd
    fontconfig
    fzf
    gfortran
    git
    # git-credential-manager # git-credential-manager github login
    jq
    lazygit
    lua
    mpv
    oh-my-zsh
    openssh
    pandoc
    parallel
    pomodoro
    python3
    rename
    ripgrep
    sd
    sops
    speedtest-rs
    starship
    sxiv
    trashy
    unzip
    vim
    wget
    xdg-ninja
    zellij
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
    unstable.zotero-beta

    mucommander # ugly af but works, weird shortcuts
    flake-inputs.superfile.packages.${system}.default

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
    rofi-calc

    grim
    slurp
    wl-clipboard
    swappy
  ];
}
