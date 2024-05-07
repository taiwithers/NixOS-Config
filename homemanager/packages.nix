{
  config,
  pkgs,
  lib,
  ...
}: let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "sublimetext4"
        ];
      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
    };
  };
in {
  # allow specific proprietary packages
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "dell-command-configure"
      "discord"
      "obsidian"
      "realvnc-vnc-viewer"
      "slack"
      "vscode-extension-MS-python-vscode-pylance"
      "vscode-extension-ms-vscode-remote-remote-ssh"
      "zoom"
    ];

  # allow select insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
    "openssl-1.1.1w"
  ];

  home.packages = with pkgs; [
    alejandra # nix file formatter
    appimage-run # allows nixos to run appimages
    bash
    bat # cat with syntax highlighting
    btop
    unstable.copyq
    conda
    curl
    dconf # gnome settings
    dell-command-configure # provides cctk command: https://dl.dell.com/content/manual29368104-dell-command-configure-version-4-x-command-line-interface-reference-guide.pdf?language=en-us
    discord
    eza # better ls
    unstable.fastfetch
    fd # better find
    filezilla
    firefox
    fzf # fuzzy finder
    gfortran
    git
    github-desktop
    gnome.gnome-tweaks
    gparted
    # htop
    jq
    keepassxc
    lazygit
    libreoffice
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    # micromamba
    obsidian
    onedrive
    onedrivegui
    openssh
    pandoc
    parallel
    pomodoro
    python3
    realvnc-vnc-viewer
    rename
    ripgrep
    slack-dark
    speedtest-rs
    unstable.sublime4
    teams-for-linux
    tilix
    trashy
    unzip
    vim
    wget
    xdg-ninja
    zip
    zoom-us
    unstable.zotero_7
    zsh

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      '';
      # bashrcExtra = ''
      #   eval '$(ssh-agent)'
      # '';
    };

    bat = {
      enable = true;
    };

    btop = {
      enable = true;
    };

    eza = {
      enable = true;
      # enableBashIntegration = true;
      git = true;
      icons = true;
    };

    # fd = {
    #   enable = true;
    #   hidden = true;
    # };

    firefox = {
      enable = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    git = {
      enable = true;
      signing.key = "/home/tai/.ssh/id_ed25519_github.pub";
      signing.signByDefault = true;
      userEmail = "59430904+taiwithers@users.noreply.github.com";
      userName = "taiwithers";

      extraConfig = {
        gpg.format = "ssh";
        pull.rebase = false;
      };

      includes = [
        {path = builtins.fetchurl "https://raw.githubusercontent.com/dandavison/delta/master/themes.gitconfig";}
      ];

      delta = {
        enable = true;
        options = {
          dark = true;
          features = "mellow-barbet"; # delta theme
          side-by-side = true;
          # file-style = "omit";
          tabs = 4;
        };
      };
    };

    gpg = {
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
    lazygit = {
      enable = true;
      settings = {};
    };

    # pandoc = {
    #   enable = true;
    # };

    ripgrep = {
      enable = true;
    };

    ssh = {
      enable = true;
      # addKeysToAgent = "confirm";
      userKnownHostsFile = "~/.ssh/known_hosts";
      matchBlocks = {
        "github.com" = {
          user = "git";
          hostname = "github.com";
          # preferredAuthentications = "publickey";
          identityFile = "~/.ssh/id_ed25519_github";
          # addKeysToAgent = "yes";
          identitiesOnly = true;
        };
        "Group Machine" = {
          user = "twithers";
          hostname = "130.15.29.221";
          identityFile = "~/.ssh/id_ed25519_groupmachine";
        };
      };
    };
  };

  services.copyq.enable = true;
  services.copyq.package = unstable.copyq;
}
