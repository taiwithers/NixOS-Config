{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland.url = "github:hyprwm/Hyprland?submodules=1";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ flake-inputs: let
    # pkgs = import nixpkgs;
    hostName = "nixos";
  in {
    nixosConfigurations."${hostName}" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit flake-inputs hostName;};
      modules = [./configuration.nix];
    };
  };
}
