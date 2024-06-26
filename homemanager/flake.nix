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
    # nix-colors.url = "github:misterio77/nix-colors";
    superfile.url = "github:yorukot/superfile";
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
        self: super: {
          unstable = import nixpkgs-unstable {
            system = builtins.currentSystem;
            # this won't work in the pkgs declaration
            # so pkgs-config gets applied in packages.nix
            config = pkgs-config;
          };
        }
      ];
    };
    nixpkgs.config = pkgs-config;
  in {
    homeConfigurations = {
      "twithers" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit flake-inputs user pkgs-config;};

        modules = with flake-inputs; [
          ./home.nix
        ];
      };
    };
  };
}
