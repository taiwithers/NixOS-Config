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
  imports = [
    # (import ./pkgs/agenix/agenix.nix {
    #   inherit config pkgs;
    #   inherit (flake-inputs) agenix;
    # })

    #(import ./themeing.nix {
    #inherit config;
    #inherit pkgs;
    #inherit (flake-inputs) stylix;
    #})

    (import ./pkgs/niri.nix {
      inherit config;
      inherit pkgs;
      inherit (flake-inputs) niri;
    })

    #./gaming.nix
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
      #"latex"
      "lazygit"
      "neovim/neovim"
      #"pdftools"
      # "python/python"
      "ripgrep"
      "rofi/rofi" # uses colours
      "starship"
      #"sublime-text/sublime-text"
      "tldr"
      #"vscodium/vscodium"
      # "xdg"
      "yazi"
      #"zotero/zotero"
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
    #cbonsai
    cloc
    dconf
    fastfetch
    #jless # https://jless.io/user-guide
    jq
    #lavat
    #libqalculate # provides qalc cmd
    #lua
    #parallel
    #pond
    #rogue
    #starfetch
    #tokei
    #ugrep
    #unar
    #wiki-tui
    #wl-clipboard
    #xdg-ninja
    # xwayland-satellite-stable # niri

    # gui programs
    #deskflow
    #imv
    #karp
    #kdePackages.ark # archive manager
    #kdePackages.dolphin
    #keepassxc
    #prismlauncher
    #qjournalctl
    #vlc
    #discord
    #sonic-pi
    #anki

    #kdePackages.kdialog
    #heroic
    #ventoy-full-qt

  ];

  programs.ssh.enable = true;

  # fonts.fontconfig.enable = true;

  programs.bash.bashrcExtra = ''
    # add completions
    complete -F _command get-package-path
    complete -F _command whichl
  '';
  #xresources.path = "${config.common.configHome}/X11/xresources";
  #home.shellAliases = {
  #"install-smapi" = "steam-run ./internal/linux/SMAPI.installer";
  #};

  common.nixConfigDirectory = "${config.home.homeDirectory}/Nix";
  common.useXDG = true;
  common.nixos = true;

  home.stateVersion = "25.11";
}
