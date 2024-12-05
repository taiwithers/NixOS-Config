{
  config,
  pkgs,
  flake-inputs,
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
        inherit config;
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
        "sublime-text/sublime-text" 
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
      imv
      kdePackages.ark # archive manager
      kdePackages.dolphin
      keepassxc
      gaia
      libreoffice-qt6-still
      masterpdfeditor
      obsidian
      onedrive
      onedrivegui
      # onlyoffice-desktopeditors
      krita
      qjournalctl
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
      Description = "Shiori bookmark manager";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Restart = "always";
      ExecStart = "${pkgs.shiori}/bin/shiori serve";
      Type= "exec";
    };
  };

  xdg.configFile."onedrive-gui/gui_settings".text = ''
    [SETTINGS]
    start_minimized = True
    frameless_window = False
    combined_start_stop_button = True
    show_debug = False
    save_debug = False
    log_rotation_interval = 12
    log_backup_count = 3
    log_file = /tmp/onedrive-gui/onedrive-gui.log
    debug_level = WARNING
    client_bin_path = onedrive
    qwebengine_login = False
  '';
  
  xresources.path = "${config.common.configHome}/X11/xresources";

  common.nixConfigDirectory = "${config.home.homeDirectory}/Nix";
  common.useXDG = true;
  common.nixos = true;

  home.stateVersion = "23.11";
}
