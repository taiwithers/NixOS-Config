{
  description = "Home Manager Configuration";

  inputs = {
    # update on version change
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";

    # leave alone
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # additional inputs
    nix-colors.url = "github:misterio77/nix-colors";
    superfile.url = "github:yorukot/superfile";
    arc.url = "github:arcnmx/nixexprs";
    nixvim.url = "github:nix-community/nixvim/nixos-24.05";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ flake-inputs: let
    pkgs-config = {
      allowUnfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [
          "dell-command-configure"
          "discord"
          "obsidian"
          "realvnc-vnc-viewer"
          "slack"
          "sublimetext4"
          "vivaldi"
          "vscode-extension-MS-python-vscode-pylance"
          "vscode-extension-ms-vscode-remote-remote-ssh"
          "zoom"
        ];
      permittedInsecurePackages = ["openssl-1.1.1w"];
    };

    pkgs = import nixpkgs {
      overlays = [
        (self: super: {
          unstable = import nixpkgs-unstable {
            system = builtins.currentSystem;
            # putting nixpkgs.config = pkgs-config; in this file errors
            # so pkgs-config gets applied in packages.nix
            config = pkgs-config;
          };
        })
      ];
    };
  in {
    homeConfigurations = {
      "tai" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = let user = "tai"; in {inherit flake-inputs user pkgs-config;};
        modules = with flake-inputs; [./home.nix];
      };
      "twithers" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = let user = "twithers"; in {inherit flake-inputs user pkgs-config;};
        modules = with flake-inputs; [./group-home.nix];
      };
    };
  };
}
