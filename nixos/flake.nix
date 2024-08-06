{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ flake-inputs: {
    nixosConfigurations = {
      main = let
        hostName = "nixos";
      in
        nixpkgs.lib.nixosSystem {
          specialArgs = {inherit flake-inputs hostName;};
          modules = [./main/configuration.nix];
        };

      wsl = let
        hostName = "wsl-nixos";
      in
        nixpkgs.lib.nixosSystem {
          specialArgs = {inherit flake-inputs hostName;};
          modules = [
            ./wsl/configuration.nix
            flake-inputs.nixos-wsl.nixosModules.default
            {
              system.stateVersion = "24.05";
              wsl.enable = true;
            }
          ];
        };
    };
  };
}
