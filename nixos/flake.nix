{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      ...
    }@flake-inputs:
    let
      configurations = {
        main = "nixos";
        wsl = "wsl-nixos";
      };

    in
    {
      nixosConfigurations = builtins.mapAttrs (
        config-name: hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit flake-inputs hostname;
          };
          modules = [
            (./. + "/${config-name}/configuration.nix")
            nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
          ];
        }
      ) configurations;
    };
}
