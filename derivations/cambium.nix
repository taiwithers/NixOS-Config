# build with nix-build --expr 'with import <nixpkgs> {}; callPackage ./cambium.nix {}'
{
  lib,
  fetchPypi,
  fetchFromGitHub,
  python3Packages,
  pagefind, # using nixpkgs pagefind, which is not pagefind-extended
}:

python3Packages.buildPythonPackage rec {
  pname = "cambium";
  version = "1.0.0-rc.2";

  src = fetchFromGitHub {
    owner = "sidratresearch";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-nIZ0+Ku/LVYiRPCAlN0gnlOh7HpIMM1Nu+nxR4R2vuU=";
  };

  prePatch =
    let
      nixpkgs_pydantic =
        if (lib.versionAtLeast python3Packages.pydantic.version "2.13") then
          throw "Remove Pydantic version constraint"
        else
          python3Packages.pydantic.version;

      nixpkgs_typer =
        if (lib.versionAtLeast python3Packages.typer.version "0.25.1") then
          throw "Remove typer version constraint"
        else
          python3Packages.typer.version;
    in
    ''
      substituteInPlace pyproject.toml \
        --replace-fail 'pydantic>=2.13.4,<3' 'pydantic==${nixpkgs_pydantic}' \
        --replace-fail 'typer>=0.25.1,<0.26' 'typer==${nixpkgs_typer}' \
    '';

  pyproject = true;
  build-system = [
    python3Packages.poetry-core
    python3Packages.poetry-dynamic-versioning
  ];

  dependencies =
    with python3Packages;
    let
      pagefind-python = buildPythonPackage rec {
        # just the python wrapper, does not include the binary
        pname = "pagefind";
        version = "1.5.2";
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-//3dbiAWsGvcqDuD1KxL7zec8FWfBezbaQiocpon2/M=";
        };
        pyproject = true;
        build-system = [ python3Packages.hatchling ];
      };
    in
    [
      jinja2
      marko
      pagefind
      pagefind-python
      pydantic
      python-slugify
      pyyaml
      typer
    ];
}
