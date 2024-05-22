{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.url = "github:hyprwm/Hyprland?submodules=1";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    # pkgs = import nixpkgs;
  in {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [./configuration.nix];
    };
  };
}
