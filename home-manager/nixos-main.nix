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

      (import ./pkgs/spotify.nix {inherit (flake-inputs) spicetify-nix;})
      flake-inputs.stylix.homeManagerModules.stylix
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
        "vesktop/vesktop"
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

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/eighties.yaml";
    fonts = rec {
        monospace.package = pkgs.intel-one-mono;
        monospace.name = "Intel One Mono";
        sansSerif.package = pkgs.open-sans;
        sansSerif.name = "Open Sans";
        serif.package = sansSerif.package;
        serif.name = sansSerif.name;
        sizes = {
            applications = 12;
            desktop = 12;
            popups = 10;
            terminal = 12;
          };
    };
    cursor = {
        package = pkgs.posy-cursors;
        name = "Posy_Cursor_Black";
        size = 32;
    };
    opacity = {
      applications = 0.8;
      desktop = 0.8;
      popups = 0.8;
      terminal = 0.5;
    };
    targets = {
        bat.enable = true;
        fzf.enable = true;
        gtk.enable = false; # doesn't follow breeze theme
        kde.enable = false; # requires wallpaper to be set
        kitty.enable = true;
        lazygit.enable = true;
        neovim.enable = true;
        rofi.enable = false; # conflicts with rofi layout styling
        spicetify.enable = true;
        vesktop.enable = true;
        vscode.enable = true;
        yazi.enable = true;
      };
  };

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
      teams-for-linux
      zoom-us
      zotero
      sticky
      signal-desktop
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
