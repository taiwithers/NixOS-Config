{
  config, 
  pkgs,
  app-themes,
  ...
}: let
  shell-scripts = builtins.attrValues (
    builtins.mapAttrs
    (name: fname: pkgs.writeShellScriptBin name (builtins.readFile ../scripts/${fname}.sh))
    {
      get-package-dir = "get-package-dir";
      # rebuild = "rebuild";
      search = "nix-search-wrapper";
      gmv = "git-mv";
      bright = "brightness-control";
      clean = "clean";
    }
  );
in {
  imports = map (fname: import (./. + "/pkgs/${fname}.nix") {inherit config pkgs app-themes;}) [
    # just noting here that these programs *are* installed
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
    "neovim/neovim"
    "python/python"
    "starship"
    "sublime-text/sublime-text"
    "superfile"
    "tilix"
    "vscodium/vscodium"
    "zoxide"
    "zsh"
  ];

  home.packages = with pkgs;
    [
      # nix programs
      appimage-run
      dconf2nix
      deadnix
      nix-diff
      nix-output-monitor # sudo nixos-rebuild [usual options] |& nom
      nix-prefetch-scripts
      nix-search-cli # provides nix-search
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
      python3
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
      # realvnc-vnc-viewer
      slack-dark
      teams-for-linux
      vivaldi
      zathura
      zoom-us
      zotero

      # hyprland extras
      # libsForQt5.qt5.wayland
      # qt6.qtwayland
      # rofi-calc
      # unstable.dunst
      # xdg-desktop-portal-gtk # in configuration.nix
      eww # eww-wayland is not necessary
      kitty # hyprland default
      rofi-wayland
      swaybg
      xdg-desktop-portal-hyprland
      rofi-calc
      waybar
      # socat

      clipse
      # cliphist # https://github.com/sentriz/cliphist?tab=readme-ov-file#listen-for-clipboard-changes
      shotman # screenshots when on wayland compositor
      # grim
      slurp
      wl-clipboard
      swappy
    ]
    ++ shell-scripts;
}
