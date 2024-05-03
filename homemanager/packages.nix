{
  config,
  pkgs,
  ...
}: let
  unstable = import <nixos-unstable> {};
in {
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
    gnome.gnome-tweaks
    gparted
    htop
    jq
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
    wget
    zip
    zoom-us
    unstable.zotero_7

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
      bashrcExtra = ''
              eval '$(ssh-agent)
              # >>> mamba initialize >>>
        # !! Contents within this block are managed by 'mamba init' !!
        export MAMBA_EXE="/nix/store/dl7cr9z41j3dsfcdiz170pgxd7pkaxih-micromamba-1.4.4/bin/micromamba";
        export MAMBA_ROOT_PREFIX="/home/tai/micromamba";
        __mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__mamba_setup"
        else
            if [ -f "/home/tai/micromamba/etc/profile.d/micromamba.sh" ]; then
                . "/home/tai/micromamba/etc/profile.d/micromamba.sh"
            else
                export  PATH="/home/tai/micromamba/bin:$PATH"  # extra space after export prevents interference from conda init
            fi
        fi
        unset __mamba_setup
        # <<< mamba initialize <<<

      '';
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
}
