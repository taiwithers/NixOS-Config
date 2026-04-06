# Python DevShells

## Initial setup of Python

Include the following snippets in the `flake.nix`:

```nix
micromamba-wrapped = pkgs.buildFHSEnv {
        name = "micromamba"; # executable inside env
        LD_LIBRARY_PATH = "${libraries}";
        runScript = "${pkgs.micromamba}/bin/micromamba";
      };
```

Then include `micromamba-wrapped` in the list of packages available within the devshell.

Enter the shell (`nix develop`) and create an environment with Python only:

```bash
micromamba env create --name <<environment name>> -- python=3.13
```

Exit the shell.

Then make a `.envrc` with the following:

```bash
#!/usr/bin/env bash

use flake .
eval "$(micromamba shell hook --shell=posix)"
micromamba activate <<environment name>>
```

Run `direnv allow` to reload the environment, which should activate both the devshell (giving access to `micromamba`), and the Python virtual environment.

## If dependencies are managed by Conda

Install packages and create environments as normal. Update the `.envrc` file to point to the correct environment name if necessary.

## If dependencies are managed by Poetry

Follow the above instructions first.

Add `poetry` to the list of devshell packages. The `nixpkgs-unstable` channel may have a more up to date version than `nixos-YY.MM`.

Enter the environment and run `poetry install`.

This should install the packages requested by a `pyproject.toml` into the virtual environment managed by micromamba. This will allow installable scripts to be run directly (e.g., `jupyter` rather than `poetry run jupyter`).
