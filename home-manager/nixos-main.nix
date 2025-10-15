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
      # (
      #   let
      #     autostart-pkgs = with pkgs; [ onedrivegui ];
      #   in
      #   import ../scripts/autostart.nix { inherit config pkgs autostart-pkgs; }
      # )

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
      # (import ./pkgs/vesktop/vesktop.nix {
      #   inherit config pkgs colours;
      #   inherit (flake-inputs) nixcord;
      # })
      (import ./pkgs/niri.nix {
        inherit config;
        inherit pkgs;
        inherit (flake-inputs) niri;
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
        # "blesh" # uses colours
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
        "pdftools"
        # "python/python"
        "ripgrep"
        "rofi/rofi" # uses colours
        "starship"
        "sublime-text/sublime-text"
        "tldr"
        "vscodium/vscodium"
        "xdg"
        "yazi"
        "zotero/zotero"
        "zoxide"
      ]
    );

  home.packages = with pkgs; [
    # nix programs
    nix-output-monitor # sudo nixos-rebuild [usual options] |& nom
    nix-search-tv

    # cli programs
    brightness-control
    broot
    cbonsai
    cloc
    dconf
    fastfetch
    jless # https://jless.io/user-guide
    jq
    lavat
    libqalculate # provides qalc cmd
    lua
    parallel
    pond
    rogue
    starfetch
    tokei
    ugrep
    unar
    wiki-tui
    wl-clipboard
    xdg-ninja
    xwayland-satellite-stable

    # gui programs
    deskflow
    ds9
    imv
    karp
    kdePackages.ark # archive manager
    kdePackages.dolphin
    keepassxc
    krita
    kdePackages.okular
    onedrivegui
    onlyoffice-desktopeditors
    prismlauncher
    qjournalctl
    qownnotes
    vlc
    zoom-us
    discord
    sonic-pi
    
    kdePackages.kdialog
    heroic
    ventoy-full-qt

  ];
  
  programs.ssh.enable = true;

  fonts.fontconfig.enable = true;

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

  programs.bash.bashrcExtra = ''
    # add completions
    complete -F _command get-package-path
    complete -F _command whichl
  '';
  xresources.path = "${config.common.configHome}/X11/xresources";

  common.nixConfigDirectory = "${config.home.homeDirectory}/Nix";
  common.useXDG = true;
  common.nixos = true;

  home.stateVersion = "23.11";
}
