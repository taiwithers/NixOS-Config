{
  description = "Project Description";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "nix-systems";
    };
    nix-systems.url = "github:nix-systems/default";
  };

  outputs =
    { nixpkgs, ... }@flake-inputs:
    let
      nixpkgs-for-system = sys: nixpkgs.legacyPackages.${sys};

      # system-specific items
      system = flake-inputs.flake-utils.lib.system.x86_64-linux;
      pkgs = nixpkgs-for-system system;

      libraries = pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.zlib
      ];

      micromamba-wrapped = pkgs.buildFHSEnv {
        name = "micromamba"; # executable inside env
        LD_LIBRARY_PATH = "${libraries}";
        runScript = "${pkgs.micromamba}/bin/micromamba";
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        name = "devshell";
        LD_LIBRARY_PATH = "${libraries}";
        packages = [
          # micromamba-wrapped
          # pkgs.poetry
          # pkgs.nodejs_latest
        ];
      };
    };
}
