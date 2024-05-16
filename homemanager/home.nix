{
  config,
  pkgs,
  lib,
  inputs,
  user,
  system,
  nix-flatpak,
  ...
}: let
  unstable-pkgs =
    import (builtins.fetchTarball {
      url = "github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz";
      # sha256 = "1506hd482n7qb55niqjx4789swjrqyng21xvzfwagq1nr173kd88";
      sha256 = "0gdi0awmqd14ii472ghxh1f2q6br0qq359i35jsw9zd30d8l1ian";
    }) {
      config = config.nixpkgs.config;
      system = system;
    };

  theme-config = rec {
    # nix-colors = import inputs.nix-colors.homeManagerModules.default;
    # colours = nix-colors."${name}";
    names = [
      "da-one-ocean" # dark vibrant
      "horizon-terminal-dark" # vibrant, good!
      "framer"
      "ayu-dark"
      "hardcore"
      "porple" # washed out, grey-blue background
      "qualia" # black + vibrant pastels
      "rose-pine" # purple
      "zenbones" # orange/green/blue on black
    ];
  };

  selectAvailableTheme = functionGetThemePath: let
    themes = theme-config.names;
    checkTheme = name: builtins.pathExists (functionGetThemePath name);
    firstAvailableTheme =
      import ../nix-scripts/choose-option-or-backup.nix
      {
        functionOptionIsValid = checkTheme;
        allOptions = themes;
      };
  in
    firstAvailableTheme;

  homeDirectory = "/home/${user}";
in {
  nixpkgs.config.allowUnfree = true; # having trouble with vscode extensions

  imports = [
    nix-flatpak.homeManagerModules.nix-flatpak
    (import ./packages.nix {inherit pkgs lib unstable-pkgs;})
    (import ./desktop-environment {inherit config pkgs unstable-pkgs;})
    (import ./package-configuration {inherit config pkgs unstable-pkgs lib selectAvailableTheme;})
  ];

  home.username = user;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
