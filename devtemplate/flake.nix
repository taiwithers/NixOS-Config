{
  description = "Template for Python Development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "nix-systems";
    };

    nix-systems.url = "github:nix-systems/default";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@flake-inputs:
    let
      treefmt-for-system =
        system:
        flake-inputs.treefmt-nix.lib.evalModule (nixpkgs-for-system system) {
          programs = {
            # generic
            dos2unix.enable = true;

            # python
            mypy.enable = true; # static type checker
            ruff-check.enable = true;
            ruff-format.enable = true;

            # other
            nixfmt.enable = true;
            shellcheck.enable = true;

          };
        };

      system = flake-inputs.flake-utils.lib.system.x86_64-linux;
      nixpkgs-for-system = sys: nixpkgs.legacyPackages.${sys};

    in
    {
      # nix fmt
      formatter.${system} = (treefmt-for-system system).config.build.wrapper;

      # nix flake check
      checks.${system} = {
        formatting = (treefmt-for-system system).config.build.check self;
      };

      devShells.${system}.default =
        let
          pkgs = nixpkgs-for-system system;
        in
        pkgs.mkShell {
          LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
          packages = with pkgs; [
            zlib
            poetry
            # hatch
          ];
        };

    };
}
