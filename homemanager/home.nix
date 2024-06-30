{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  ...
}: let
  app-themes = with (import ../scripts/theme-config.nix {
      inherit pkgs;
      inherit (flake-inputs) arc;
    }); let
    defaultTheme = "base16/da-one-ocean";
  in {
    palettes = makePaletteSet {
      tilix = defaultTheme;
      superfile = defaultTheme;
    };
    filenames = makePathSet {
      fzf = defaultTheme;
      sublime-text = defaultTheme;
    };
  };

  homeDirectory = "/home/${user}";
in {
  imports = [
    flake-inputs.nixvim.homeManagerModules.nixvim
    (import ./packages.nix {inherit pkgs pkgs-config flake-inputs;})
    (import ./desktop-environment {inherit config pkgs;})
    (import ./pkgs {inherit config pkgs app-themes;})
  ];

  home.username = user;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
