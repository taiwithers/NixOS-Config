{
  config,
  pkgs,
  flake-inputs,
  # user,
  # pkgs-config,
  app-themes,
  colours,
  fonts,
  ...
}:
{
  imports =
    [
      (
        let
          autostart-pkgs = with pkgs; [ onedrivegui ];
        in
        import ../scripts/autostart.nix { inherit config autostart-pkgs; }
      )
      flake-inputs.agenix.homeManagerModules.default
    ]
    ++ (map
      (
        fname:
        import (./. + "/pkgs/${fname}.nix") {
          inherit
            config
            pkgs
            app-themes
            colours
            ;
        }
      )
      [
        "agenix/agenix"
        "bash"
        "bat"
        # "betterdiscord"
        "blesh"
        "bottom"
        "cod"
        # "copyq/copyq"
        "duf"
        "dust"
        "eza"
        "firefox/firefox"
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
        "rofi"
        # "tofi"
        "starship"
        "sublime-text/sublime-text"
        # "tilix"
        "vscodium/vscodium"
        "xdg"
        # "yazi"
        # "zellij"
        "zoxide"
        # "zsh"
      ]
    )
    ++ [
      (import ./pkgs/plasma/plasma.nix {
        inherit
          config
          pkgs
          flake-inputs
          app-themes
          colours
          ;
      })
    ]
    ++ [ ./gaming.nix ];

  home.packages =
    with pkgs;
    [
      # nix programs
      # appimage-run
      # dconf2nix
      deadnix
      # nix-diff
      nix-output-monitor # sudo nixos-rebuild [usual options] |& nom
      # nix-prefetch-scripts
      nix-tree
      # nurl
      nixfmt
      clean
      get-package-path
      nixos-generations
      search
      nixshell

      # cli programs
      age # encryption
      cbonsai
      cloc
      curl
      dconf
      # dell-command-configure
      fastfetch
      fd
      # file
      # fontconfig
      jq
      latex
      lavat
      libqalculate # provides qalc cmd
      lua
      onefetch
      pandoc
      parallel
      pdf2svg # for eps file preview
      pond
      rename
      # ripgrep-all
      sd
      # speedtest-rs
      starfetch
      trashy
      unzip
      wget
      unar
      xdg-ninja
      wl-clipboard
      # zbar
      zip
      parted
      brightness-control
      tealdeer
      pdftk
      yazi

      # gui programs
      color-oracle
      ds9
      # filezilla
      github-desktop
      gparted
      keepassxc
      libreoffice
      kdePackages.dolphin
      kdePackages.ark # archive manager
      # gwenview
      obsidian
      onlyoffice-desktopeditors
      onedrive
      onedrivegui
      pinta
      imv
      # realvnc-vnc-viewer
      spotify
      teams-for-linux
      zoom-us
      zotero
      sticky
      signal-desktop
      vesktop
      masterpdfeditor
    ]
    ++ fonts;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  xdg.configFile."tealdeer/config.toml".text = ''
    [display]
    use_pager = true
    compact = true

    [updates]
    auto_update = true
  '';
  services.caffeine.enable = true;

  home.shellAliases."TA" = "cd ${config.home.homeDirectory}/OneDrive_Staff && pyactivate ta && codium .";

  common.nixConfigDirectory = "${config.common.configHome}/NixOS-Config";
  common.useXDG = true;
  common.nixos = true;

  home.stateVersion = "23.11";
}
