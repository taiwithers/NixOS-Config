{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.url = "github:taiwithers/home-manager/FirefoxProfiles";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # libraries for other inputs to follow
    systems.url = "github:nix-systems/default";
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    # other inputs
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";
    agenix.inputs.home-manager.follows = "home-manager";
    agenix.inputs.systems.follows = "systems";

    arc.url = "github:arcnmx/nixexprs";
    arc.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
    nix-colors.inputs.nixpkgs-lib.follows = "nixpkgs-lib";

    plasma-manager.url = "github:nix-community/plasma-manager/trunk";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    nur.url = "github:nix-community/NUR";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.inputs.flake-compat.follows = "flake-compat";

    stylix.url = "github:danth/stylix";
    stylix.inputs.base16-fish.follows = "";
    stylix.inputs.base16-helix.follows = "";
    stylix.inputs.base16-vim.follows = "";
    stylix.inputs.flake-compat.follows = "flake-compat";
    stylix.inputs.flake-utils.follows = "flake-utils";
    stylix.inputs.gnome-shell.follows = "";
    stylix.inputs.home-manager.follows = "home-manager";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.systems.follows = "systems";
    stylix.inputs.tinted-foot.follows = "";
    stylix.inputs.tinted-tmux.follows = "";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@flake-inputs:
    let
      pkgs-config = {
        allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "tetrio-desktop"
            "dell-command-configure"
            "discord"
            "masterpdfeditor"
            "obsidian"
            "posy-cursors"
            "realvnc-vnc-viewer"
            "slack"
            "spotify"
            "sublimetext4"
            "vivaldi"
            "vscode-extension-MS-python-vscode-pylance"
            "vscode-extension-ms-vscode-remote-remote-ssh"
            "zoom"
          ];
        permittedInsecurePackages = [ "openssl-1.1.1w" ];
      };

      pkgs = import nixpkgs {
        overlays =
          let
            system = builtins.currentSystem;
          in
          [
            (self: super: rec {
              unstable = import nixpkgs-unstable {
                system = system;
                # putting nixpkgs.config = pkgs-config; in this file errors
                # so pkgs-config gets applied in common.nix
                config = pkgs-config;
              };
            })
            flake-inputs.nur.overlay
            (import ./overlays.nix { inherit pkgs flake-inputs system; })
          ];
      };

      colours =
        with builtins;
        with flake-inputs.nix-colors.lib.conversions;
        rec {
          hex-hashless = {
            black = "000000";
            navy = "171726";
            dark-blue = "22273d";
            dark-grey = "525866";
            blue-grey = "444A8F";
            grey = "878d96";
            light-grey = "c8c8c8";
            ivory = "FFEFD5";
            white = "ffffff";
            red = "fa7883";
            peach = "ffc387";
            salmon = "ff9470";
            green = "98c379";
            cyan = "8af5ff";
            light-blue = "6bb8ff";
            pink = "e799ff";
            brown = "b3684f";
            maroon = "673136";
            yellow = "FFE492";
            orange = "FF893D";
            lime = "82C247";
            purple = "9B81FF";
            sky = "008CFF";
            indigo = "351774";
            tan = "DEB887";
          };
          hex-hash = mapAttrs (name: value: "#${value}") hex-hashless;
          rgb255-commasep = mapAttrs (name: value: hexToRGBString "," value) hex-hashless;
        };

      app-themes =
        with (import ../scripts/theme-config.nix {
          inherit pkgs;
          inherit (flake-inputs) arc;
        });
        makePathSet rec {
          fzf = "base16/da-one-ocean";
          sublime-text = fzf;
        };

      fonts = with pkgs; [
        cm_unicode
        intel-one-mono
        open-sans
        dejavu_fonts
        (nerdfonts.override {
          fonts = [
            # "IntoneMono" # not available in nixpkgs nerdfont
            "SpaceMono"
            "NerdFontsSymbolsOnly"
          ];
        })
      ];

      configurations = {
        nixos-main = "tai"; # linux partition
        ubuntu-main = "twithers"; # group machine
        nixos-wsl = "tai-wsl"; # wsl on  windows partition
        ubuntu-wsl = "tai-wsl"; # currently unused
      };
    in
    {
      homeConfigurations = builtins.mapAttrs (
        config-name: user:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              flake-inputs
              user
              pkgs-config
              colours
              app-themes
              fonts
              config-name
              ;
          };
          modules = [
            (./. + "/${config-name}.nix")
            ./common.nix
          ];
        }
      ) configurations;

    };
}
