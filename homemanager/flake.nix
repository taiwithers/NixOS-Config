{
  description = "Home Manager Configuration";

  inputs = {
    # update on version change
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";

    # leave alone
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # additional inputs
    # lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
    # lix-module.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    superfile.url = "github:yorukot/superfile";
    arc.url = "github:arcnmx/nixexprs";
    nixvim.url = "github:nix-community/nixvim/nixos-24.05";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@flake-inputs:
    let
      pkgs-config = {
        allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "dell-command-configure"
            "discord"
            "obsidian"
            "realvnc-vnc-viewer"
            "slack"
            "sublimetext4"
            "vivaldi"
            "vscode-extension-MS-python-vscode-pylance"
            "vscode-extension-ms-vscode-remote-remote-ssh"
            "zoom"
          ];
        permittedInsecurePackages = [ "openssl-1.1.1w" ];
      };

      pkgs = import nixpkgs {
        overlays =
          let
            system = builtins.currentSystem;
            custom = fname: pkgs.callPackage fname { };
          in
          [
            (self: super: rec {
              unstable = import nixpkgs-unstable {
                system = system;
                # putting nixpkgs.config = pkgs-config; in this file errors
                # so pkgs-config gets applied in packages.nix
                config = pkgs-config;
              };

              cbonsai = custom ./derivations/cbonsai.nix;
              color-oracle = custom ./derivations/color-oracle.nix;
              ds9 = custom ./derivations/ds9.nix;
              fzf = unstable.fzf;
              gaia = custom ./derivations/gaia.nix;
              neovim = unstable.neovim-unwrapped;
              nixfmt = unstable.nixfmt-rfc-style;
              pond = custom ./derivations/pond.nix;
              starfetch = custom ./derivations/starfetch.nix;
              superfile = flake-inputs.superfile.packages.${system}.default;
              zotero = unstable.zotero-beta;
            })
          ];
      };

      app-themes =
        with (import ../scripts/theme-config.nix {
          inherit pkgs;
          inherit (flake-inputs) arc;
        });
        let
          defaultTheme = "base16/da-one-ocean";
        in
        {
          palettes = makePaletteSet {
            tilix = defaultTheme;
            superfile = defaultTheme;
          };
          filenames = makePathSet {
            fzf = defaultTheme;
            sublime-text = defaultTheme;
          };
        };

    in
    {
      homeConfigurations =
        builtins.mapAttrs
          (
            user: files:
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = {
                inherit
                  flake-inputs
                  user
                  pkgs-config
                  app-themes
                  ;
              };
              modules = with flake-inputs; files ++ [./common.nix];
            }
          )
          {
            tai = [ ./home.nix ];
            twithers = [ ./group-home.nix ];
            tai-wsl = [ ./wsl-home.nix ];
          };
    };
}
