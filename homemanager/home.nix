{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  ...
}: let
  theme-config = rec {
    nix-colors = flake-inputs.nix-colors;
    # nix-colors-module = import nix-colors.homeManagerModules.default;
    colour-palette = nix-colors.colorSchemes."${builtins.head names}".palette;
    names = [
      "da-one-ocean" # dark vibrant
      "jabuti" # not available in nix-colors
      "horizon-terminal-dark" # vibrant, good!
      "framer"
      "ayu-dark"
      "hardcore"
      "porple" # washed out, grey-blue background
      "qualia" # black + vibrant pastels
      "rose-pine" # purple
      "zenbones" # orange/green/blue on black
    ];

    app-themes = builtins.mapAttrs (appName: appTheme: nix-colors.colorSchemes."${appTheme}".palette) {
      tilix = "da-one-ocean"; # change this once nix-colors supports base 24
      superfile = "gruvbox-dark-hard";
    };

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
    (import ./packages.nix {inherit pkgs pkgs-config flake-inputs;})
    (import ./desktop-environment {inherit config pkgs;})
    (import ./pkgs {inherit config pkgs theme-config;})
  ];

  gtk = rec {
    enable = true; # enable gtk 2/3 config
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    iconTheme = theme;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  home.username = user;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
