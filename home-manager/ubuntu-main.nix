{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  app-themes,
  ...
}: {
  imports = map (fname: import ./pkgs/${fname}.nix {inherit config pkgs app-themes;}) [
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
    "lazygit"
    "neovim/neovim"
    "python/python"
    "starship"
    "superfile"
    "zoxide"
  ];
  home.packages = with pkgs;
    [
      fastfetch
      fd
      latex
      kitty # use icat on remote
      nix-output-monitor
      nixfmt
      ripgrep
      trashy
      xdg-ninja
    ]
    ++ builtins.attrValues (
      builtins.mapAttrs
      (name: fname: pkgs.writeShellScriptBin name (builtins.readFile ../scripts/${fname}.sh))
      {
        get-package-dir = "get-package-dir";
        gmv = "git-mv";
        clean = "clean";
      }
    );

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

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 7d";
  };

  common.nixConfigDirectory = "${config.common.configHome}/NixOS-Config";
  common.useXDG = true;
  common.nixos = false;
  home.shellAliases."storagespace" = "dust --no-percent-bars --depth 0 --no-colors --skip-total --full-paths /1-Data-Fast /2-Data-Medium /3-Data-Slow /home/$USER /nix";

  home.stateVersion = "24.05";
}
