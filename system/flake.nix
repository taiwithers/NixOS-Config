{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    pkgs = import nixpkgs;
  in {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      modules = [./configuration.nix];
    };
  };
}
