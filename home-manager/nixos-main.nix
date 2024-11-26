{
  config,
  pkgs,
  flake-inputs,
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

      (import ./pkgs/agenix/agenix.nix {
        inherit config pkgs;
        inherit (flake-inputs) agenix;
      })
      (import ./pkgs/spotify.nix {
        inherit pkgs;
        inherit (flake-inputs) spicetify-nix;
      })
      (import ./themeing.nix {
        inherit pkgs;
        inherit (flake-inputs) stylix;
      })
      (import ./pkgs/plasma/plasma.nix {
        inherit config pkgs colours;
        inherit (flake-inputs) plasma-manager;
      })

      ./gaming.nix
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
        "bash"
        "bat"
        "blesh" # uses colours
        "bottom"
        "cod"
        "duf"
        "dust"
        "eza"
        "firefox/firefox"
        "fzf"
        "git" # also installed system-wide
        "kitty"
        "lazygit"
        "neovim/neovim"
        "python/python"
        "ripgrep"
        "rofi/rofi" # uses colours
        "starship"
        "sublime-text/sublime-text" # uses app-themes
        "tldr"
        "vesktop/vesktop"
        "vscodium/vscodium"
        "xdg"
        "yazi"
        "zoxide"
      ]
    );

  home.packages =
    with pkgs;
    [
      # nix programs
      deadnix
      nix-output-monitor # sudo nixos-rebuild [usual options] |& nom
      nix-tree

      # cli programs
      brightness-control
      cbonsai
      cloc
      dconf
      fastfetch
      jq
      latex
      lavat
      libqalculate # provides qalc cmd
      lua
      pandoc
      parallel
      parted
      pdf2svg # for eps file preview
      pdftk
      pond
      starfetch
      unar
      wl-clipboard
      xdg-ninja

      # gui programs
      # color-oracle
      ds9
      gparted
      imv
      kdePackages.ark # archive manager
      kdePackages.dolphin
      keepassxc
      libreoffice
      gaia
      masterpdfeditor
      obsidian
      onedrive
      onedrivegui
      # onlyoffice-desktopeditors
      pinta
      # realvnc-vnc-viewer
      signal-desktop
      shiori
      sticky
      teams-for-linux
      zoom-us
      zotero
    ]
    ++ fonts;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.caffeine.enable = true;

  systemd.user.services.shiori = {
    Unit = {
      Description = "Run shiori bookmark manager";
    };
    Install = {
      WantedBy = [ "multi-user.target" ];
    };
    Service = {
      Restart = "always";
      ExecStart = "${pkgs.shiori}/bin/shiori serve";
    };
  };
  xresources.path = "${config.common.configHome}/X11/xresources";

  common.nixConfigDirectory = "${config.common.configHome}/NixOS-Config";
  common.useXDG = true;
  common.nixos = true;

  home.stateVersion = "23.11";
}
