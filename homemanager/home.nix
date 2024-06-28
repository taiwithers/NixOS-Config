{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  ...
}: let
  # theme-config = rec {
  #   nix-colors = flake-inputs.nix-colors;
  #   # nix-colors-module = import nix-colors.homeManagerModules.default;
  #   colour-palette = nix-colors.colorSchemes."${builtins.head names}".palette;
  #   names = [
  #     "da-one-ocean" # dark vibrant
  #     "jabuti" # not available in nix-colors
  #     "horizon-terminal-dark" # vibrant, good!
  #     "framer"
  #     "ayu-dark"
  #     "hardcore"
  #     "porple" # washed out, grey-blue background
  #     "qualia" # black + vibrant pastels
  #     "rose-pine" # purple
  #     "zenbones" # orange/green/blue on black
  #   ];
  #   app-themes = builtins.mapAttrs (appName: appTheme: nix-colors.colorSchemes."${appTheme}".palette) {
  #     tilix = "da-one-ocean"; # change this once nix-colors supports base 24
  #     superfile = "da-one-ocean";
  #   };
  #   # function: select available theme
  #   selectAvailableTheme = functionGetThemePath: let
  #     checkTheme = name: builtins.pathExists (functionGetThemePath name);
  #     firstAvailableTheme =
  #       import ../scripts/choose-option-or-backup.nix
  #       {
  #         functionOptionIsValid = checkTheme;
  #         allOptions = names;
  #       };
  #   in
  #     firstAvailableTheme;
  # };
  # theme-config = import ../scripts/theme-config.nix {inherit (flake-inputs) nix-colors;};
  app-themes = let
    defaultTheme = "base16/da-one-ocean";

    colourschemes = pkgs.fetchFromGitHub {
      owner = "tinted-theming";
      repo = "schemes";
      rev = "ef9a4c3";
      hash = "sha256-9i9IjZcjvinb/214x5YShUDBZBC2189HYs26uGy/Hck=";
    };

    importYaml = let
      findStrings = ["palette:" "  "];
      replaceStrings = builtins.genList (str: "") (builtins.length findStrings);
    in
      theme:
        flake-inputs.arc.lib.fromYAML (
          builtins.replaceStrings findStrings replaceStrings (
            builtins.readFile "${colourschemes}/${theme}.yaml"
          )
        );

    toFileName = theme:
      pkgs.lib.toLower (
        builtins.replaceStrings ["/" " "] ["-" "-"] theme
      );
  in {
    palettes = builtins.mapAttrs (name: value: importYaml value) {
      tilix = defaultTheme;
      superfile = defaultTheme;
    };

    filenames = builtins.mapAttrs (name: value: toFileName value) {
      fzf = defaultTheme;
      sublime-text = defaultTheme;
    };
  };

  homeDirectory = "/home/${user}";
in {
  imports = [
    # nix-flatpak.homeManagerModules.nix-flatpak
    (import ./packages.nix {inherit pkgs pkgs-config flake-inputs;})
    (import ./desktop-environment {inherit config pkgs;})
    (import ./pkgs {inherit config pkgs app-themes;})
  ];

  # home.file."testoutput".text = app-themes.tilix.palette.base00;
  # home.file."testoutput".text = app-themes.tilix.palette;
  # home.file."testoutput".text = builtins.toString (builtins.attrNames app-themes.tilix.palette);
  # home.file."testoutput".text = builtins.toString (builtins.attrNames flake-inputs.arc.lib);
  # systemd.user.enable = true;

  home.username = user;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
