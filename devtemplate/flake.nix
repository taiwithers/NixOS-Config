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

    ignoreboy = {
      url = "github:ookiiboy/ignoreboy";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "nix-systems";
      inputs.pre-commit-hooks.follows = "git-hooks";
    };
  };

  outputs =
    {
      nixpkgs,
      ...
    }@flake-inputs:
    let

      nixpkgs-for-system = sys: nixpkgs.legacyPackages.${sys};

      # system-specific items
      system = flake-inputs.flake-utils.lib.system.x86_64-linux;
      pkgs = nixpkgs-for-system system;
      gitignore-creator =
        language-list:
        flake-inputs.ignoreboy.lib.${system}.gitignore {
          github.languages = language-list;
          useSaneDefaults = true; # adds OS and Nix-specific entries
          extraConfig = ''
            *:Zone.Identifier # added when copying from windows to WSL via explorer
          '';
        };
      # define wrapper for mkShell
      mkDevShell =
        {
          name ? "dev",
          required-packages ? [ ],
          gitignore-languages ? [ ],
        }:
        pkgs.mkShell {
          inherit name;
          shellHook = ''
            if [[ ! -f ".envrc" ]]; then
              cp .envrc-${name} ./.envrc
            fi
            if [[ -e .envrc-* ]]; then
              rm .envrc-*
            fi
            ${gitignore-creator gitignore-languages}
          '';
          LD_LIBRARY_PATH = "${libraries}:$LD_LIBRARY_PATH";
          packages = required-packages ++ extra-packages;
        };

      # edit on a per-project basis
      libraries = pkgs.lib.makeLibraryPath (
        with pkgs;
        [
          stdenv.cc.cc.lib
          zlib
        ]
      );
      extra-packages = with pkgs; [
        just
      ];

    in
    {

      devShells.${system} = {
        # nix develop .#<shellname>

        python = mkDevShell {
          # python -m venv .venv
          # .venv/bin/pip install git+<repository>
          # .venv/bin/<executable>
          name = "python";
          required-packages = [ pkgs.python3 ];
          gitignore-languages = [
            "Python"
            "community/Python/JupyterNotebooks"
          ];
        };

        python-poetry = mkDevShell {
          # git clone <repository>
          # cd <repository>
          # poetry install
          # poetry run <executable>
          name = "python-poetry";
          required-packages = [ pkgs.poetry ];
        };

        nodejs = mkDevShell {
          name = "nodejs";
          required-packages = [ pkgs.nodejs_23 ];
          gitignore-languages = [ "Node" ];
        };

      };
    };
}
