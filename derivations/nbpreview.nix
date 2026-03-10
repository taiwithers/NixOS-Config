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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'ipython = "^9.6.0"' 'ipython = ">9.0.0"' \
      --replace 'Pillow = ">=8.3.1,<11.0.0"' 'Pillow = ">=8.3.1"' \
      --replace 'mdit-py-plugins = ">=0.5.0"' 'mdit-py-plugins = ">0.4.0"' \
      --replace 'rich = ">=14.2.0"' 'rich = ">14.0.0"' 
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
