{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:GermanBread/declarative-flatpak/stable";

    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nix-flatpak,
    # vscode-server,
    ...
  } @ inputs: let
    user = "tai";
    system = "x86_64-linux";
    # pkgs = nixpkgs.legacyPackages.${system};
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (
          final: prev: {
            unstable = nixpkgs-unstable.legacyPackages.${prev.system};
          }
        )
      ];
    };
  in {
    homeConfigurations."${user}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit nix-flatpak user system;
      };

      modules = [
        nix-flatpak.homeManagerModules.default
        ./home.nix
      ];
    };
  };
}
