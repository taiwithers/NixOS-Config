{
  description = "Home Manager Configuration";

  inputs = {
    # update on version change
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";

    # leave alone
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # additional flake inputs
    nix-flatpak.url = "github:GermanBread/declarative-flatpak/stable";
    nix-colors.url = "github:misterio77/nix-colors";
    # sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nix-flatpak,
    nix-colors,
    # sops-nix,
    # vscode-server,
    ...
  } @ inputs: let
    user = "tai";
    system = "x86_64-linux";

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
      permittedInsecurePackages = [
        # "electron-25.9.0"
        "openssl-1.1.1w"
      ];
    };

    unstable-overlay = self: super: {
      unstable = import nixpkgs-unstable {
        system = system;

        # this won't work in the pkgs declaration
        # so pkgs-config gets applied in packages.nix
        config = pkgs-config;
      };
    };

    pkgs = import nixpkgs {
      overlays = [unstable-overlay];
    };
  in {
    homeConfigurations."${user}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit nix-flatpak nix-colors user system pkgs-config;
      };

      modules = [
        nix-flatpak.homeManagerModules.default
        # sops-nix.nixosModules.sops
        ./home.nix
      ];
    };
  };
}
