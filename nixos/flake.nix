{
  description = "NixOS Configuration";

  inputs = {
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
