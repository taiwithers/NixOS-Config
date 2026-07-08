{
  lib,
  makeBinaryWrapper,
  nodejs,
  bun,
  fetchFromGitHub,
  stdenv,
}:
let
  pname = "gh-actions-language-server";
  version = "unstable-2026-07-07";
  src = fetchFromGitHub {
    owner = "lttb";
    repo = "gh-actions-language-server";
    rev = "dcbb17fc6c6af3484f59c75959c6b132760d9f5d";
    hash = "sha256-u6xslwSEoa1Ex7tD40j8ndWkwQ0YO+VitxZG9t/mvKM=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "${pname}-node-modules";
    inherit version src;
    nativeBuildInputs = [ bun ];
    dontConfigure = true;

    buildPhase = ''
      runHook preBuild
      export HOME=$TMPDIR
      bun install --frozen-lockfile --no-progress
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r node_modules $out/
      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-WXMIUvdiels1NimJCYZiPA9M7NO64jVi6Ifw5HjDc3o=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    nodejs
    bun
    makeBinaryWrapper
  ];

  configurePhase = ''
    runHook preConfigure
    ln -s ${node_modules}/node_modules node_modules
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    export HOME=$TMPDIR
    bun run build:node
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/gh-actions-language-server
    mkdir -p $out/bin

    # Copy source files and dependencies
    cp -r . $out/lib/gh-actions-language-server/
    rm $out/lib/gh-actions-language-server/node_modules
    cp -r ${node_modules}/node_modules $out/lib/gh-actions-language-server/

    # Create wrapper script
    makeBinaryWrapper ${nodejs}/bin/node $out/bin/gh-actions-language-server \
      --add-flags "$out/lib/gh-actions-language-server/bin/gh-actions-language-server"

    runHook postInstall
  '';

  doInstallCheck = true;

}
