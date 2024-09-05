{
  description = "Home Manager Configuration";

  inputs = {
    # update on version change
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";

    # leave alone
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # additional inputs
    superfile.url = "github:yorukot/superfile";
    arc.url = "github:arcnmx/nixexprs";
    agenix.url = "github:ryantm/agenix";
    plasma-manager.url = "github:nix-community/plasma-manager/trunk";
    nix-colors.url = "github:misterio77/nix-colors";
    ags.url = "github:Aylur/ags";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    superfile.inputs.nixpkgs.follows = "nixpkgs";
    arc.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";
    agenix.inputs.home-manager.follows = "home-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";


  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ flake-inputs: let
    pkgs-config = {
      allowUnfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [
          "dell-command-configure"
          "discord"
          "obsidian"
          "posy-cursors"
          "realvnc-vnc-viewer"
          "slack"
          "sublimetext4"
          "vivaldi"
          "vscode-extension-MS-python-vscode-pylance"
          "vscode-extension-ms-vscode-remote-remote-ssh"
          "zoom"
        ];
      permittedInsecurePackages = ["openssl-1.1.1w"];
    };

    pkgs = import nixpkgs {
      overlays = let
        system = builtins.currentSystem;
      in [
        (self: super: rec {
          unstable = import nixpkgs-unstable {
            system = system;
            # putting nixpkgs.config = pkgs-config; in this file errors
            # so pkgs-config gets applied in common.nix
            config = pkgs-config;
          };
        })
        (import ./overlays.nix {inherit pkgs flake-inputs system;})
      ];
    };

    app-themes = with (import ../scripts/theme-config.nix {
      inherit pkgs;
      inherit (flake-inputs) arc;
    }); let
      defaultTheme = "base16/da-one-ocean";
      # 0 very dark grey
      # 1 dark blue
      # 2 very dark grey
      # 3 medium
      # 4 light grey
      # 5-7 white
      # 8 red
      # 9 peach
      # A orange
      # B green
      # C very light blue
      # D light blue
      # E lilac
      # F brown

    in {
      palettes = makePaletteSet {
        kde = defaultTheme;
        kitty = defaultTheme;
        neovim = defaultTheme;
        superfile = defaultTheme;
        tilix = defaultTheme;
        tofi = defaultTheme;
        zellij = defaultTheme;
      };
      filenames = makePathSet {
        fzf = defaultTheme;
        sublime-text = defaultTheme;
      };
    };

    fonts = with pkgs; [
      cm_unicode
      intel-one-mono
      (nerdfonts.override {
        fonts = [
          # "IntoneMono" # not available in nixpkgs nerdfont
          "SpaceMono"
          "NerdFontsSymbolsOnly"
        ];
      })
    ];

    configurations = {
      nixos-main = "tai"; # linux partition
      ubuntu-main = "twithers"; # group machine
      nixos-wsl = "tai-wsl"; # wsl on  windows partition
      ubuntu-wsl = "tai-wsl"; # currently unused
    };
  in {
    homeConfigurations =
      builtins.mapAttrs (
        config-name: user:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {inherit flake-inputs user pkgs-config app-themes fonts config-name;};
            modules = [(./. + "/${config-name}.nix") ./common.nix];
          }
      )
      configurations;

    formatter.${builtins.currentSystem} = nixpkgs.legacyPackages.${builtins.currentSystem}.alejandra;
  };
}
