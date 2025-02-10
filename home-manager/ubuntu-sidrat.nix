{
  config,
  pkgs,
  colours,
  ...
}:
{
  imports =
    map
      (
        fname:
        import ./pkgs/${fname}.nix {
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
        "bottom"
        "blesh"
        "cod"
        "common-git"
        "duf"
        "dust"
        "eza"
        "fzf"
        "kitty" # use icat on remote
        # "latex"
        "lazygit"
        "neovim/neovim"
        "pdftools"
        # "python/python"
        "ripgrep"
        "sublime-text/sublime-text"
        "starship"
        "tldr"
        "zoxide"
      ];
  home.packages = with pkgs; [
    fastfetch
    libqalculate
    nix-output-monitor
    xdg-ninja
  ];

  programs.git = {
    extraConfig = {
      credential.credentialStore = "gpg";
    };
      signing.key = pkgs.lib.mkForce null;
      signing.signByDefault = pkgs.lib.mkForce false;
  };

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 7d";
  };

  common.nixConfigDirectory = "${config.common.userHome}/Nix";
  common.useXDG = true;
  common.nixos = false;
  # home.shellAliases."storagespace" =
  # "dust --no-percent-bars --depth 0 --no-colors --skip-total --full-paths /1-Data-Fast /2-Data-Medium /3-Data-Slow /home/$USER /nix";
  home.stateVersion = "24.11";
}
