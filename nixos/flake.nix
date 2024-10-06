{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs =
    {
      self,
      nixpkgs,
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
          ];
        }
      ) configurations;
    };
}
