{
  description = "Home Manager Configuration";

  # extra-flakes = {
  #   nix-flatpak.url = "github:GermanBread/declarative-flatpak/stable";
  #   nix-colors.url = "github:misterio77/nix-colors";
  #   sops-nix.url = "github:Mic92/sops-nix";
  #   superfile.url = "github:yorukot/superfile";
  # };

  inputs = {
    # update on version change
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";

    # leave alone
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # additional inputs
    # nix-flatpak.url = "github:GermanBread/declarative-flatpak/stable";
    nix-colors.url = "github:misterio77/nix-colors";
    superfile.url = "github:yorukot/superfile";
    arc.url = "github:arcnmx/nixexprs";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    # extra-flakes,
    # nix-flatpak,
    # nix-colors,
    # superfile,
    # vscode-server,
    ...
  } @ flake-inputs: let
    user = "tai";

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
        "openssl-1.1.1w"
      ];
    };

    unstable-overlay = self: super: {
      unstable = import nixpkgs-unstable {
        system = builtins.currentSystem;

        # this won't work in the pkgs declaration
        # so pkgs-config gets applied in packages.nix
        config = pkgs-config;
      };
    };

    pkgs = import nixpkgs {overlays = [unstable-overlay];};
  in {
    homeConfigurations."${user}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit flake-inputs user pkgs-config;};

      modules = with flake-inputs; [
        # nix-flatpak.homeManagerModules.default
        # nix-colors.homeManagerModules.default
        ./home.nix
      ];
    };
  };
}
