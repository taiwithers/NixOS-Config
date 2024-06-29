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

  custom-derivations = map (pname: (pkgs.callPackage ./derivations/${pname}.nix {})) [
    "ds9"
    "gaia"
    "starfetch"
  ];

  installed-with-program-enable = with pkgs; [
    # just noting here that these programs *are* installed
    bash
    bat
    copyq
    eza
    fzf
    git # also installed system-wide
    starship
    zsh
  ];
in {
  nixpkgs.config = pkgs-config;
  home.packages = with pkgs;
    [
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
      brightnessctl
      bottom
      chafa # cli images
      cloc
      cod # completion from --help
      conda
      curl
      dconf
      dell-command-configure
      duf # view general info for entire system
      dust # view specific info for directories
      fastfetch
      fd
      file
      fontconfig
      gfortran
      imv
      jq
      lazygit
      lua
      mpv
      onefetch
      openssh
      pandoc
      parallel
      # unstable.pistol # integrate into fzf preview for archive viewing, otherwise unnecesary
      pomodoro
      python3
      rename
      ripgrep
      sd
      speedtest-rs
      trashy
      unzip
      vim
      wget
      xdg-ninja
      zellij
      zip
      zoxide

      # gui programs
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
      # realvnc-vnc-viewer
      slack-dark
      sublime4
      teams-for-linux
      tilix
      vivaldi
      vscodium-fhs
      zoom-us
      unstable.zotero-beta

      # mucommander # ugly af but works, weird shortcuts
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
      waybar
      # socat

      clipse
      # cliphist # https://github.com/sentriz/cliphist?tab=readme-ov-file#listen-for-clipboard-changes
      shotman # screenshots when on wayland compositor
      # grim
      slurp
      wl-clipboard
      swappy
    ]
    ++ custom-derivations;
}
