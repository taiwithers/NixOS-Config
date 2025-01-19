{
  config,
  pkgs,
  flake-inputs,
  colours,
  ...
}:
{
  # nixos-rebuild switch --install-bootloader --use-remote-sudo --flake ./path-to-flake#output-name
  # nix run home-manager/release-24.11 -- switch --impure --flake ./path-to-flake#output-name
  imports =
    [
      (
        let
          autostart-pkgs = with pkgs; [ onedrivegui ];
        in
        import ../scripts/autostart.nix { inherit config pkgs autostart-pkgs; }
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
        "latex"
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
        "zotero/zotero"
        "zoxide"
      ]
    );

  home.packages = with pkgs; [
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
    ghostscript # pdf creation
    jq
    lavat
    libqalculate # provides qalc cmd
    lua
    pandoc
    parallel
    pdftk
    pond
    starfetch
    unar
    wl-clipboard
    xdg-ninja

    # gui programs
    ds9
    imv
    kdePackages.ark # archive manager
    kdePackages.dolphin
    keepassxc
    # gaia
    # libreoffice-qt6-still
    libreoffice-qt6-fresh
    masterpdfeditor
    obsidian
    onedrivegui
    karp
    krita
    qjournalctl
    signal-desktop
    shiori
    teams-for-linux
    zoom-us
    okular

  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.caffeine.enable = true;

  fonts.fontconfig.enable = true;

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
      Type = "exec";
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
