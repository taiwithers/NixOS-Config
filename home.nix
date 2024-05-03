{
  config,
  pkgs,
  ...
}: let
  unstable = import <nixos-unstable> {};
in {
  imports = [
    "/home/tai/.config/nixfiles/autostart.nix"
    "/home/tai/.config/nixfiles/fonts.nix"
  ];
  home.username = "tai";
  home.homeDirectory = "/home/tai";

  # allow proprietary packages
  nixpkgs.config.allowUnfree = true;

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
    unstable.copyq
    curl
    dell-command-configure # provides cctk command: https://dl.dell.com/content/manual29368104-dell-command-configure-version-4-x-command-line-interface-reference-guide.pdf?language=en-us
    discord
    eza # better ls
    fd # better find
    filezilla
    firefox
    fzf # fuzzy finder
    gfortran
    git
    github-desktop
    gnome-extension-manager
    gnome.gnome-tweaks
    gparted
    htop
    keepassxc
    lazygit
    libreoffice
    micromamba
    obsidian
    onedrive
    onedrivegui
    openssh
    pandoc
    parallel
    pomodoro
    python3
    realvnc-vnc-viewer
    # redshift # doesn't work on wayland
    rename
    ripgrep
    slack-dark
    speedtest-rs
    sublime4
    teams-for-linux
    # tlp # no use on dell :(
    trashy
    unzip
    vim
    vscodium-fhs
    wget
    zip
    zoom-us
    unstable.zotero_7
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

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
      bashrcExtra = "eval '$(ssh-agent)'";
    };

    bat = {
      enable = true;
      config = {};
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
      delta.enable = true;
      signing.key = null; # lets GnuPG decide, in .gitconfig is /home/tai/.ssh/id_ed25519_github.pub
      signing.signByDefault = true;
      userEmail = "taiwithers@users.noerply.github.com";
      userName = "taiwithers";
    };

    htop = {
      enable = true;
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

  # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shellAliases
  home.shellAliases = {
    "grep" = "rg";
    "untar" = "tar -xvf";
    "ls" = "eza --long --colour=always --icons=always --hyperlink --all --group-directories-first --header --time-style iso --no-permissions --no-user --git";
    "tree" = "eza --tree --colour=always --icons=always --hyperlink --all --group-directories-first --header --time-style iso --no-permissions --no-user --git";
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.settings
  # nix.settings = {
  #   auto-optimise-store = true;
  #   experimental-features = "nix-command";
  # };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # or
  #  /etc/profiles/per-user/tai/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
