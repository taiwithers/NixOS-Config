{
  description = "Project Description";

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

    ignoreboy = {
      url = "github:ookiiboy/ignoreboy";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "nix-systems";
      inputs.pre-commit-hooks.follows = "git-hooks";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@flake-inputs:
    let
      # system-agnostic items
      treefmt-for-system =
        system:
        flake-inputs.treefmt-nix.lib.evalModule (nixpkgs-for-system system) {
          programs = {
            # generic
            dos2unix.enable = true;

            # python
            mypy.enable = true; # static type checker
            black.enable = true;

            # other
            nixfmt.enable = true;
            shfmt.enable = true;
            shellcheck.enable = true;
          };
        };

      nixpkgs-for-system = sys: nixpkgs.legacyPackages.${sys};
      gitignore-for-system = sys: flake-inputs.ignoreboy.lib.${sys}.gitignore {
            github.languages = [
              "Python"
              "community/Python/JupyterNotebooks"
            ];
            useSaneDefaults = true; # adds OS and Nix-specific entries
            extraConfig = ''
              *.py:Zone.Identifier
            '';
          };



      # system-specific items
      system = flake-inputs.flake-utils.lib.system.x86_64-linux;
      gitignore = gitignore-for-system system;
      pkgs = nixpkgs-for-system system;
      libraries = pkgs.lib.makeLibraryPath (
        with pkgs;
        [
          stdenv.cc.cc.lib
          zlib
        ]
      );
      extra-packages = with pkgs; [
        # add any packages needed for the specific project
      ];


    in
    {
      # nix fmt
      formatter.${system} = (treefmt-for-system system).config.build.wrapper;

      devShells.${system} = {
        # nix develop .#<shellname>

        python-poetry = pkgs.mkShell {
          # git clone <repository>
          # cd <repository>
          # poetry install
          # poetry run <executable>
          name = "python-poetry";
          shellHook = "${gitignore}";
          LD_LIBRARY_PATH = "${libraries}";
          packages = [ pkgs.poetry ] ++ extra-packages;
        };

        python = pkgs.mkShell {
          # python -m venv .venv
          # .venv/bin/pip install git+<repository>
          # .venv/bin/<executable>
          name = "python";
          shellHook = "${gitignore}";
          LD_LIBRARY_PATH = "${libraries}";
          packages = [ pkgs.python3 ] ++ extra-packages;
        };

      };
    };
}
