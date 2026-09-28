# build with nix-build --expr 'with import <nixpkgs> {}; callPackage ./cambium.nix {}'
{
  fetchPypi,
  fetchFromGitHub,
  python3Packages,
  pagefind,
}:

python3Packages.buildPythonPackage rec {
  pname = "cambium";
  commit = "abedb8c";
  version = "0.6.0.dev0";

  src = fetchFromGitHub {
    owner = "sidratresearch";
    repo = pname;
    rev = commit;
    hash = "sha256-V1BVpcW4yVt9/+9Dwr2apYFPm9Z/tWgpzNK6CA3MhIQ=";
  };

  postPatch =
    let
      nixpkgs_pydantic = "2.12.5";
      nixpkgs_typer = "0.24.0";
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
