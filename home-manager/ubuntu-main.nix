{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  app-themes,
  colours,
  ...
}:
{
  imports = map (fname: import ./pkgs/${fname}.nix { inherit config pkgs app-themes colours; }) [
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
    "lazygit"
    "neovim/neovim"
    "python/python"
    "starship"
    # "superfile"
    "zoxide"
  ];
  home.packages = with pkgs; [
    nixshell
    fastfetch
    fd
    latex
    kitty # use icat on remote
    kalker
    nix-output-monitor
    nixfmt
    ripgrep
    sd
    trashy
    xdg-ninja
    get-package-path
    clean
  ];

  programs.bash.bashrcExtra = ''
    # GAIA
    shopt -u expand_aliases
    source $STARLINK_DIR/etc/profile
    shopt -s expand_aliases
  '';

  programs.git = {
    extraConfig = {
      credential.credentialStore = "gpg";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 7d";
  };

  common.nixConfigDirectory = "${config.common.configHome}/NixOS-Config";
  common.useXDG = true;
  common.nixos = false;
  home.shellAliases."storagespace" = "dust --no-percent-bars --depth 0 --no-colors --skip-total --full-paths /1-Data-Fast /2-Data-Medium /3-Data-Slow /home/$USER /nix";
  home.shellAliases."uqwork" = "cd /2-Data-Medium/UncertainQuantity && micromamba activate packaging";
  home.stateVersion = "24.05";
}
