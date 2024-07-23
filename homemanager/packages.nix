{
  pkgs,
  pkgs-config,
  flake-inputs,
  ...
}:
let
  texlive-pkgs = pkgs.texlive.combine {
    inherit (pkgs.texlive)
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

  shell-scripts = builtins.attrValues (
    builtins.mapAttrs
      (name: fname: pkgs.writeShellScriptBin name (builtins.readFile ../scripts/${fname}.sh))
      {
        get-package-dir = "get-package-dir";
        rebuild = "rebuild";
        search = "nix-search-wrapper";
        gmv = "git-mv";
        bright = "brightness-control";
        clean = "clean";
      }
  );

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
    lazygit
    starship
    zsh
  ];
in
{
  nixpkgs.config = pkgs-config;
  home.packages =
    with pkgs;
    [
      # nix programs
      appimage-run
      dconf2nix
      deadnix
      nix-diff
      nix-output-monitor # sudo nixos-rebuild [usual options] |& nom
      nix-prefetch-scripts
      nix-search-cli # provides nix-search
      nix-tree
      nurl
      nixfmt

      # cli programs
      age # encryption
      brightnessctl
      cbonsai
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
      lua
      mpv
      onefetch
      openssh
      pandoc
      parallel
      pdf2svg # for eps file preview
      # unstable.pistol # integrate into fzf preview for archive viewing, otherwise unnecesary
      pomodoro
      pond
      python3
      rename
      ripgrep
      ripgrep-all
      sd
      speedtest-rs
      starfetch
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
      ds9
      filezilla
      gaia
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
    ++ shell-scripts;
}
