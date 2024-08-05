{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    { self, nixpkgs, ... }@flake-inputs:
    let
      # pkgs = import nixpkgs;
      hostName = "nixos";
    in
    {
      nixosConfigurations."${hostName}" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit flake-inputs hostName;
        };
        modules = [
          ./configuration.nix
          flake-inputs.sops-nix.nixosModules.sops
        ];
      };
    };
}
