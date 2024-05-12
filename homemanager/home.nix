{
  config,
  pkgs,
  lib,
  inputs,
  user,
  system,
  ...
} @ args: let
  unstable-pkgs =
    import (builtins.fetchTarball {
      url = "github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz";
      sha256 = "1506hd482n7qb55niqjx4789swjrqyng21xvzfwagq1nr173kd88";
    }) {
      config = config.nixpkgs.config;
      system = system;
    };

  autostart-pkgs = with pkgs; [
    teams-for-linux
    unstable-pkgs.copyq
    onedrivegui
  ];

  taskbar-pkgs = with pkgs; [
    firefox
    dolphin
    sublime4
    tilix
    vscodium-fhs
    obsidian
  ];

  custom-keyboard-shortcuts = [
    {
      name = "Open Dolphin";
      command = "dolphin";
      binding = "<Super>e";
    }
    {
      name = "Open Settings";
      command = "gnome-control-center";
      binding = "<Super>i";
    }
  ];

  theme-config = rec {
    # nix-colors = import inputs.nix-colors.homeManagerModules.default;
    # colours = nix-colors."${name}";
    names = ["ayu-dark" "hardcore"];
  };

  # selectAvailableTheme = functionGetThemePath: let
  #   checkTheme = name: builtins.pathExists (functionGetThemePath name);
  #   availableThemes = builtins.filter checkTheme theme-config.names;
  #   firstAvailableTheme = builtins.head availableThemes;
  # in
  #   firstAvailableTheme;

  selectAvailableTheme = functionGetThemePath: let
    themes = theme-config.names;
    checkTheme = name: builtins.pathExists (functionGetThemePath name);
    firstAvailableTheme =
      import ./modules/choose-option-or-backup.nix
      {
        functionOptionIsValid = checkTheme;
        allOptions = themes;
      };
  in
    firstAvailableTheme;

  # making a change??/

  locateDesktop = import ./modules/locate-desktop.nix;
in {
  imports = [
    (import ./modules/packages.nix {inherit pkgs lib unstable-pkgs;})
    (import ./modules/autostart.nix {inherit config autostart-pkgs;})
    (import ./modules/custom-keyboard-shortcuts.nix {inherit custom-keyboard-shortcuts;})
    ./modules/default-keyboard-shortcuts.nix
    (import ./modules/gnome-extensions.nix {inherit pkgs;})
    ./modules/fonts.nix
    (import ./modules/vscodium-configuration.nix {inherit config pkgs lib;})
    (import ./modules/sublime-text.nix {inherit config pkgs theme-config;})
  ];
  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true; # having issues w/ vscode extensions...

  programs.git = {
    enable = true;
    signing.key = "/home/${user}/.ssh/id_ed25519_github.pub";
    signing.signByDefault = true;
    userEmail = "59430904+taiwithers@users.noreply.github.com";
    userName = "taiwithers";
    extraConfig = {
      gpg.format = "ssh";
      pull.rebase = "false";
      init.defaultBranch = "main";
      core.whitespace.blank-at-eol = false;
      core.whitespace.blank-at-eof = false;
      # ignore-space-at-eol = true;
    };
    delta = {
      enable = true;
      options = {
        dark = true;
        side-by-side = true;
      };
    };
  };

  services.copyq = {
    enable = true;
    package = unstable-pkgs.copyq;
  };

  home.file = {
    # ".ssh/config".source = ./non-nix/ssh-config;
    # "${config.xdg.configHome}/dolphinrc".source = ./non-nix/dolphinrc;
    # "${config.xdg.stateHome}/kxmlgui5/dolphinui.rc".source = ./non-nix/dolphinui.rc;
    # "${config.xdg.configHome}/copyq/copyq.conf".source = /.non-nix/copyq.conf;
  };

  xdg = {
    enable = true;
    cacheHome = "/home/tai/.cache"; # default
    configHome = "/home/tai/.config"; # default
    dataHome = "/home/tai/.local/share"; # default
    stateHome = "/home/tai/.local/state"; # default

    desktopEntries = {};

    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/gzip" = []; # .gz , .tgz
        "application/json" = []; # .json
        "application/pdf" = ["firefox.desktop"];
        "application/zip-compressed" = []; # .zip
        "application/x-debian-package" = []; # .deb, .udeb
        "application/x-font-ttf" = []; # .ttc, .ttf
        "application/x-shellscript" = []; # .sh
        "application/x-tar" = []; # .tar
        "application/x-tex" = []; # .tex
        "application/xhtml+xml" = ["firefox.desktop"];
        "application/yaml" = []; # yaml, yml

        "application/vnd.oasis.opendocument.graphics" = []; # .odg
        "application/vnd.oasis.opendocument.graphics-template" = []; # .otg
        "application/vnd.oasis.opendocument.presentation" = []; # .odp
        "application/vnd.oasis.opendocument.presentation-template" = []; # .otp
        "application/vnd.oasis.opendocument.spreadsheet" = []; # .ods
        "application/vnd.oasis.opendocument.spreadsheet-template" = []; # .ots
        "application/vnd.oasis.opendocument.text" = []; # .odt
        "application/vnd.oasis.opendocument.text-template" = []; # .ott
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = []; # .pptx
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = []; # .docx

        "image/gif" = []; # .gif
        "image/ico" = []; # .ico
        "image/jpeg" = []; # .jpeg
        "image/png" = []; # .png
        "image/webp" = []; # .webp

        "inode/directory" = ["org.kde.dolphin.desktop"];

        "text/calendar" = []; # .ics .ifb
        "text/csv" = []; # .csv
        "text/html" = ["firefox.desktop"];
        "text/plain" = []; # .conf, .def, .diff, .in, .ksh, .list, .log, .pl, .text, .txt
        "text/x-markdown" = []; # .md, .markdown, .mdown, .markdn
        "text/x-py" = []; # .py

        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/msteams" = ["teams-for-linux.desktop"];
        "x-scheme-handler/zoom-mtg" = ["zoom.desktop"]; # not sure if correct
      };
    };
  };

  home.shellAliases = {
    "grep" = "rg";
    "untar" = "tar -xvf";
    "ls" = "eza";
    "tree" = "eza --tree";
    "rebuild" = "bash ~/.config/NixOS-Config/rebuild.sh";
    "mamba" = "micromamba";
    "man" = "batman";
  };
  programs.bash = {
    enable = true; # apply home.shellAliases to bash
    historyFile = "${config.xdg.stateHome}/bash/history"; # clean up homedir
  };
  xsession.profileExtra = "export $EDITOR=vim"; # doesn't work

  dconf.settings = {
    "org/gnome/shell" = {
      # taskbar apps
      favorite-apps = map (pkg: locateDesktop pkg) taskbar-pkgs;
      # user-theme.name = "";
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      show-battery-percentage = true;
      overlay-scrolling = true;
      locate-pointer = true;
      # cursor-theme = "";
    };

    "org/gnome/settings-daemon/plugins/power".power-button-action = "interactive";

    # multitasking
    "org/gnome/desktop/interface".enable-hot-corners = false;
    "org/gnome/mutter".edge-tiling = true;
    "org/gnome/mutter".dynamic-workspaces = true;
    "org/gnome/mutter".workspaces-only-on-primary = false;
    "org/gnome/shell/app-switcher".current-workspace-only = true;
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg"; # clean up homedir
  };

  programs.eza = {
    enable = true;
    extraOptions = [
      "--long"
      "--colour=always"
      "--hyperlink"
      "--all"
      "--group-directories-first"
      "--header"
      "--time-style=iso"
      "--no-permissions"
      "--no-user"
    ];
    git = true;
    icons = true;
  };

  dconf.settings."com/gexperts/Tilix" = {
    control-scroll-zoom = true;
    enable-wide-handle = true;
    middle-click-close = true;
    new-instance-mode = "focus-window";
    paste-strip-first-char = true;
    paste-strip-trailing-whitespace = true;
    prompt-on-close = true;
    terminal-title-style = "small";
    theme-variant = "dark";
    use-tabs = true;
  };

  # Themeing

  # download all base 16 themes to tilix theme directory
  xdg.configFile."${config.xdg.configHome}/tilix/schemes/".source = pkgs.fetchFromGitHub {
    owner = "karlding";
    repo = "base16-tilix";
    rev = "72602d8";
    hash = "sha256-QFNiQNGD6ceE1HkLESx+gV0q/pKyr478k2zVy9cc7xI=";
  };

  # set tilix theme
  # get profile string with `dconf dump /com/gexperts/Tilix/profiles`
  dconf.settings."com/gexperts/Tilix/profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d" = let
    getThemePath = name: "${config.xdg.configHome}/tilix/schemes/tilix/base16-${name}.json";
    tilixTheme = getThemePath (selectAvailableTheme getThemePath);
  in
    builtins.fromJSON (builtins.readFile tilixTheme);

  # not sure this is actually the extension I want to use
  # programs.vscode.extensions = with pkgs.vscode-utils.extensionsFromVscodeMarketplace; [
  #   {
  #     name = "Base16 Theme Switcher";
  #     publisher = "";
  #     version = "";
  #     sha256 = "";
  #   }
  # ];
}
