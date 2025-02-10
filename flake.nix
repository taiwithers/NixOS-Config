{
  description = "NixOS/Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "nix-systems";
    };

    arc = {
      url = "github:arcnmx/nixexprs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darkly = {
      url = "github:Bali10050/Darkly";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dream2nix = {
      # for nix-inspect
      url = "github:nix-community/dream2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.purescript-overlay.follows = "purescript-overlay";
    };

    flake-compat.url = "github:edolstra/flake-compat";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "nix-systems";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    nix-cargo-integration = {
      # for nix-inspect
      url = "github:yusdacra/nix-cargo-integration";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.parts.follows = "flake-parts";
      inputs.treefmt.follows = "treefmt-nix";
      inputs.dream2nix.follows = "dream2nix";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.systems.follows = "nix-systems";
    };

    nix-inspect = {
      url = "github:bluskript/nix-inspect";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.parts.follows = "flake-parts";
      inputs.nci.follows = "nix-cargo-integration";
    };

    nix-systems.url = "github:nix-systems/default";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-zoom.url = "nixpkgs/24.05"; # https://github.com/NixOS/nixpkgs/issues/322970

    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    purescript-overlay = {
      # for nix-inspect
      url = "github:thomashoneyman/purescript-overlay";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.flake-parts.follows = "flake-parts";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.systems.follows = "nix-systems";
    };

    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.base16-fish.follows = "";
      inputs.base16-helix.follows = "";
      inputs.base16-vim.follows = "";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.gnome-shell.follows = "";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "nix-systems";
      inputs.tinted-foot.follows = "";
      inputs.tinted-tmux.follows = "";
      inputs.firefox-gnome-theme.follows = "";
      # stylix.inputs.tinted-zed.follows = "";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@flake-inputs:
    let
      treefmt-for-system =
        system: flake-inputs.treefmt-nix.lib.evalModule (nixpkgs-for-system system) ./treefmt.nix;

      pkgs-config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "openssl-1.1.1w" ];
      };

      pkgs-for-system =
        system:
        import nixpkgs {
          inherit system;
          config = pkgs-config;
          overlays = [
            (_self: _super: {
              # unstable nixpkgs
              unstable = import flake-inputs.nixpkgs-unstable {
                inherit system;
                config = pkgs-config;
              };

              # packages from external flakes
              agenix = flake-inputs.agenix.packages.${system}.default;
              kdePackages = _super.kdePackages // {
                darkly = flake-inputs.darkly.packages.${system}.darkly-qt6;
                kwin-forceblur = flake-inputs.kwin-effects-forceblur.packages.${system}.default;
              };
              nix-inspect = flake-inputs.nix-inspect.packages.${system}.default;
              pipewire-zoom = flake-inputs.nixpkgs-zoom.legacyPackages.${system}.pipewire;
            })

            #  other overlays
            flake-inputs.nur.overlays.default
            (import ./overlays.nix { })
          ];
        };

      colours = with flake-inputs.nix-colors.lib.conversions; rec {
        hex-hashless = builtins.fromJSON (builtins.readFile ./colourscheme.json);
        hex-hash = builtins.mapAttrs (_name: value: "#${value}") hex-hashless;
        rgb255-commasep = builtins.mapAttrs (_name: value: hexToRGBString "," value) hex-hashless;
      };

      system = flake-inputs.flake-utils.lib.system.x86_64-linux;
      nixpkgs-for-system = sys: nixpkgs.legacyPackages.${sys};

      home-configurations = {
        nixos-main = "tai";
        ubuntu-main = "twithers";
        ubuntu-sidrat = "taiwithers";
      };

      home-module-args = { inherit flake-inputs colours; };

    in
    {
      # nix fmt
      formatter.${system} = (treefmt-for-system system).config.build.wrapper;

      # nix flake check
      checks.${system} = {
        formatting = (treefmt-for-system system).config.build.check self;
      };

      nixosConfigurations."main" = nixpkgs.lib.nixosSystem {
        pkgs = pkgs-for-system system;
        specialArgs = { inherit colours; };
        modules = [
          ./NixOS/main/configuration.nix
          flake-inputs.nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
        ];
      };

      homeConfigurations = builtins.mapAttrs (
        config-name: username:
        flake-inputs.home-manager.lib.homeManagerConfiguration rec {
          pkgs = pkgs-for-system system;
          extraSpecialArgs = home-module-args // {
            inherit config-name;
          };
          modules = [
            {
              nixpkgs.config = pkgs-config;
              home.username = username;
            }
            (./. + "/home-manager/${config-name}.nix")
            ./home-manager/common.nix
          ];
        }
      ) home-configurations;

    };
}
