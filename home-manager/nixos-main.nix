{
  config,
  pkgs,
  flake-inputs,
  # user,
  # pkgs-config,
  app-themes,
  fonts,
  ...
}: {
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
          import ../scripts/autostart.nix {inherit config autostart-pkgs;}
      )
      flake-inputs.agenix.homeManagerModules.default
    ]
    ++ (map (fname: import (./. + "/pkgs/${fname}.nix") {inherit config pkgs app-themes;}) [
      # just noting here that these programs *are* installed
      "agenix/agenix"
      "bash"
      "bat"
      "bottom"
      "cod"
      "copyq/copyq"
      "duf"
      "dust"
      "eza"
      "fzf"
      "gaia"
      "git" # also installed system-wide
      "gnome/gnome"
      # "gpg"
      "lazygit"
      "realvnc"
      "neovim/neovim"
      "python/python"
      "starship"
      "sublime-text/sublime-text"
      "superfile"
      "tilix"
      "vscodium/vscodium"
      "xdg"
      "zoxide"
      # "zsh"
    ]);

  # home.shellAliases."updatevnc" = "nix-prefetch-url --type sha256 https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-7.5.1-Linux-x64.rpm";

  home.packages = with pkgs;
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
      imv
      jq
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

      # gui programs
      discord
      ds9
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
      slack-dark
      teams-for-linux
      texpresso
      vivaldi
      zathura
      zoom-us
      zotero
    ]
    ++ (map
      (
        {
          name,
          runtimeInputs ? [],
          file,
        }:
          pkgs.writeShellApplication {
            name = name;
            runtimeInputs = runtimeInputs;
            text = builtins.readFile file;
          }
      )
      [
        rec {
          name = "get-package-dir";
          runtimeInputs = with pkgs; [
            coreutils
            which
          ];
          file = ../scripts + "/${name}.sh";
        }
        rec {
          name = "clean";
          runtimeInputs = with pkgs; [
            coreutils
            gnugrep
            gnused
            home-manager
            nix
          ];
          file = ../scripts + "/${name}.sh";
        }
        rec {
          name = "search";
          runtimeInputs = with pkgs; [
            nix-search-cli
            sd
            jq
            nix
          ];
          file = ../scripts/nix-search-wrapper.sh;
        }
      ])
    ++ fonts;

  # gnome taskbar
  dconf.settings."org/gnome/shell".favorite-apps = with pkgs;
    map (pkg: (import ../scripts/locate-desktop.nix) pkg) [
      firefox
      dolphin
      sublime4
      tilix
      codium
      obsidian
    ];

  common.nixConfigDirectory = "${config.common.configHome}/NixOS-Config";
  common.useXDG = true;
  common.nixos = true;

  home.stateVersion = "23.11";
}
