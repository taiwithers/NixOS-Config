{
  config,
  pkgs,
  lib,
  # inputs,
  user,
  nix-colors,
  # system,
  # nix-flatpak,
  pkgs-config,
  ...
}: let
  theme-config = rec {
    # nix-colors-module = import nix-colors.homeManagerModules.default;
    colours = nix-colors.colorSchemes."${builtins.head names}".palette;
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

    # function: select available theme
    selectAvailableTheme = functionGetThemePath: let
      checkTheme = name: builtins.pathExists (functionGetThemePath name);
      firstAvailableTheme =
        import ../nix-scripts/choose-option-or-backup.nix
        {
          functionOptionIsValid = checkTheme;
          allOptions = names;
        };
    in
      firstAvailableTheme;
  };

  homeDirectory = "/home/${user}";
in {
  imports = [
    # nix-flatpak.homeManagerModules.nix-flatpak
    nix-colors.homeManagerModules.default
    (import ./packages.nix {inherit pkgs pkgs-config lib;})
    (import ./desktop-environment {inherit config pkgs;})
    (import ./package-configuration {inherit config pkgs lib theme-config;})
  ];

  # colorScheme = ;

  # home.file."testoutput".text = "imports list " + builtins.concatStringsSep ", " (builtins.attrNames nix-colors.colorSchemes.da-one-ocean.palette);
  # home.file."testoutput".text = "in-set import " + builtins.concatStringsSep ", " (builtins.attrNames theme-config.nix-colors-module.colorSchemes.da-one-ocean.palette);

  home.file."testoutput".text = builtins.concatStringsSep ", " (builtins.attrNames theme-config.colours);

  home.username = user;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
