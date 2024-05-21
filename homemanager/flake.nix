{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:GermanBread/declarative-flatpak/stable";

    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nix-flatpak,
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
          "zoom"
        ];
      permittedInsecurePackages = [
        "electron-25.9.0"
        "openssl-1.1.1w"
      ];
    };

    unstable-overlay = self: super: {
      unstable = import nixpkgs-unstable {
        system = system;
        config = pkgs-config;
        # config.allowUnfree = true;
        # config.permittedInsecurePackages = ["openssl-1.1.1w"];
      };
    };

    pkgs = import nixpkgs {
      overlays = [unstable-overlay];
    };
    # pkgs.overlays = [unstable-overlay];
    # pkgs = import nixpkgs {
    #   inherit system;
    #   # config = pkgs-config;
    #   # config.allowUnfree = true;
    #   # config.permittedInsecurePackages = ["openssl-1.1.1w"];
    #   overlays = [unstable-overlay];
    # };
  in {
    homeConfigurations."${user}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit nix-flatpak user system;
      };

      modules = [
        nix-flatpak.homeManagerModules.default
        ./home.nix
      ];
    };
  };
}
