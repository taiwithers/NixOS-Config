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

      (import ./pkgs/spotify.nix {inherit pkgs; inherit (flake-inputs) spicetify-nix;})
      (import ./themeing.nix {inherit pkgs; inherit (flake-inputs) stylix;})
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
        "blesh"
        "bottom"
        "cod"
        "duf"
        "dust"
        "eza"
        "firefox/firefox"
        "fzf"
        "gaia"
        "git" # also installed system-wide
        "kitty"
        "lazygit"
        "neovim/neovim"
        "python/python"
        "ripgrep"
        "rofi/rofi"
        "starship"
        "sublime-text/sublime-text"
        "tldr"
        "vesktop/vesktop"
        "vscodium/vscodium"
        "xdg"
        "yazi"
        "zoxide"
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
      masterpdfeditor
      obsidian
      onedrive
      onedrivegui
      # onlyoffice-desktopeditors
      pinta
      # realvnc-vnc-viewer
      signal-desktop
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

  home.shellAliases."TA" = "cd ${config.home.homeDirectory}/OneDrive_Staff && pyactivate ta && codium .";

  common.nixConfigDirectory = "${config.common.configHome}/NixOS-Config";
  common.useXDG = true;
  common.nixos = true;

  home.stateVersion = "23.11";
}
