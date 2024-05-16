{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
    # nix-colors.url = "github:misterio77/nix-colors";
    # vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nix-flatpak,
    # vscode-server,
    ...
  } @ inputs: let
    user = "tai";
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."${user}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit nix-flatpak;
        # inherit inputs; # for nix-colors
        inherit user system;
      };

      modules = [
        ./home.nix
      ];
    };
  };
}
