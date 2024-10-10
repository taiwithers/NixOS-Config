{
  fetchFromGitHub,
  stdenv,
  pkgs,
  nix,
}:
stdenv.mkDerivation rec {
  pname = "dconf2nix";
  version = "63c7eab";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "dconf2nix";
    rev = version;
    hash = "sha256-kjxRPIPfkX+nzGNaJdEpwmxOeWmfz9ArXNGrCtMs+EI=";
  };

  isLibrary = true;
  isExecutable = true;
  mainprogram = "dconf2nix";

  preBuild =
    # bash
    ''
      mkdir --parents $out
      cp -r $src/* $out
      cd $out
      export OLD_HOME=$HOME
      export HOME=$out
      ${pkgs.cabal-install}/bin/cabal configure #--disable-executable-dynamic --ghc-option=-optl=-static --ghc-option=-optl=-pthread
      export HOME=$OLD_HOME
      cd $out
      echo "$(ls)"
      ${nix}/bin/nix-build 2&1>/dev/null
    '';

  libraryHaskellDepends = with pkgs.haskellPackages; [
    base
    containers
    emojis
    optparse-applicative
    parsec
    text
  ];
  executableHaskellDepends = with pkgs.haskellPackages; [ base ];
  testHaskellDepends = with pkgs.haskellPackages; [
    base
    containers
    hedgehog
    parsec
    template-haskell
    text
  ];
}
