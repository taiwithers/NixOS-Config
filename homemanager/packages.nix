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

  shell-scripts = builtins.attrValues (builtins.mapAttrs (name: fname: pkgs.writeShellScriptBin name (builtins.readFile ../scripts/${fname}.sh)) {
    get-package-dir = "get-package-dir";
    rebuild = "rebuild";
    search = "nix-search-wrapper";
    gmv = "git-mv";
    bright = "brightness-control";
  });

  installed-with-program-enable = with pkgs; [
    # just noting here that these programs *are* installed
    bash
    bat
    bottom
    copyq
    eza
    fzf
    git # also installed system-wide
    gpg
    starship
    zsh
  ];
in {
  nixpkgs.config = pkgs-config;
  home.packages = with pkgs; let
    zotero = unstable.zotero-beta;
    superfile = flake-inputs.superfile.packages.${system}.default;
  in
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
      superfile
      teams-for-linux
      tilix
      vivaldi
      vscodium-fhs
      zoom-us
      zotero

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
    ++ custom-derivations
    ++ shell-scripts;
}
