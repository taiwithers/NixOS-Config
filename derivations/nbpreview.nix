{
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonPackage rec {
  pname = "nbpreview";
  version = "0.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YUTywDFf/2+D57pSaUnTcggKx3hTzCTJhRSaBO9eWao=";
  };

  nativeBuildInputs = [
    python3Packages.poetry-core
  ];

  # https://github.com/paw-lu/nbpreview/blob/c37fe33c8a7ace26647e14b4fc47587802686fef/pyproject.toml
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'Pillow = ">=8.3.1,<11.0.0"' 'Pillow = ">=8.3.1"' \
      --replace-fail 'markdown-it-py = ">=3.0,<4.0"' 'markdown-it-py = ">=3.0"' \
      --replace-fail 'typer = "^0.19.2"' 'typer = ">=0.19.2"' \
  '';

  dependencies =
    with python3Packages;
    let
      sty = buildPythonPackage rec {
        pname = "sty";
        version = "1.0.6";
        pyproject = true;
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-1D7Lcbe60LVtYiyyGdC+MDwW/LQUO4TRRl3tIuKbqgA=";
        };
        nativeBuildInputs = [ python3Packages.poetry-core ];
      };
      picharsso = buildPythonPackage rec {
        pname = "picharsso";
        version = "2.0.1";
        pyproject = true;
        build-system = [ python3Packages.setuptools ];
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-602LGh/mknh00CNi7rJDb4a/m0/uAswKx2not2HBJ28=";
        };
        dependencies = with python3Packages; [
          click
          numpy
          pillow
          sty
        ];
      };
    in
    [
      jinja2
      pillow
      pygments
      click-help-colors
      html2text
      httpx
      ipython
      lxml
      markdown-it-py
      mdit-py-plugins
      nbformat
      picharsso
      pylatexenc
      rich
      term-image
      typer
      types-click
      validators
      yarl
    ];

}
