{
  config,
  pkgs,
  flake-inputs,
  # user,
  # pkgs-config,
  app-themes,
  fonts,
  ...
}:
{
  imports =
    [
      # autostart
      (
        let
          autostart-pkgs = with pkgs; [
            teams-for-linux
            onedrivegui
          ];
        in
        import ../scripts/autostart.nix { inherit config autostart-pkgs; }
      )
      flake-inputs.agenix.homeManagerModules.default
    ]
    ++ (map (fname: import (./. + "/pkgs/${fname}.nix") { inherit config pkgs app-themes; }) [
      # just noting here that these programs *are* installed
      "agenix/agenix"
      "bash"
      "bat"
      "betterdiscord"
      # "blesh"
      "bottom"
      "cod"
      # "copyq/copyq"
      "duf"
      "dust"
      "eza"
      "fzf"
      "gaia"
      "git" # also installed system-wide
      # "gnome/gnome"
      # "gpg"
      "kitty"
      "lazygit"
      "neovim/neovim"
      "python/python"
      "ripgrep"
      "tofi"
      "starship"
      "sublime-text/sublime-text"
      # "tilix"
      "vscodium/vscodium"
      "xdg"
      # "yazi"
      # "zellij"
      "zoxide"
      # "zsh"
    ])
    ++ [
      (import ./pkgs/plasma/plasma.nix {
        inherit
          config
          pkgs
          flake-inputs
          app-themes
          ;
      })
    ]
    ++ [ flake-inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    # configDir = "${config.common.configHome}/ags";
  };
    ++ [./gaming.nix];

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
      nix-tree
      nurl
      nixfmt
      clean
      get-package-path
      nixos-generations
      search

      # cli programs
      age # encryption
      brightnessctl
      cbonsai
      chafa # cli images
      cloc
      curl
      dconf
      dell-command-configure
      fastfetch
      fd
      file
      fontconfig
      gfortran
      jq
      kalker
      latex
      lavat
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
      powertop
      rename
      ripgrep-all
      sd
      speedtest-rs
      starfetch
      trashy
      unzip
      # vim
      wget
      xdg-ninja
      wl-clipboard
      zbar
      zip
      parted

      # gui programs
      color-oracle
      discord
      ds9
      filezilla
      github-desktop
      gparted
      keepassxc
      libreoffice
      kdePackages.dolphin
      kdePackages.ark # archive manager
      loupe # gnome imager viewer
      obsidian
      onlyoffice-desktopeditors
      onedrive
      onedrivegui
      pinta
      realvnc-vnc-viewer
      # slack-dark
      spotify # something breaks in latest flake update...
      teams-for-linux
      # texpresso
      # zathura
      zoom-us
      zotero
      caffeine-ng
      sticky

      vesktop
      klassy


      # hplip
      # gnome.adwaita-icon-theme # cursor theme?
      posy-cursors
      # kdePackages.breeze-icons
      bluez
      # bluez-tools
      # kdePackages.bluedevil
      kdePackages.bluez-qt
      # blueman

      # (papirus-icon-theme.override {color="indigo";})
      # libsForQt5.polonium
      # kdePackages.plasma-sdk
      # inkscape
    ]
    ++ fonts;


  # gnome taskbar
  dconf.settings."org/gnome/shell".favorite-apps =
    with pkgs;
    map (pkg: (import ../scripts/locate-desktop.nix) pkg) [
      firefox
      dolphin
      sublime4
      tilix
      codium
      obsidian
    ];

  # firefox work profile desktop icon
  xdg.desktopEntries."Firefox - TA" = {
    name = "Firefox - TA";
    exec = "firefox -P Work %U";
    terminal = false;
  };

  home.shellAliases."TA" = "cd ${config.home.homeDirectory}/OneDrive_Staff && pyactivate ta && codium .";

  common.nixConfigDirectory = "${config.common.configHome}/NixOS-Config";
  common.useXDG = true;
  common.nixos = true;

  home.stateVersion = "23.11";
}
