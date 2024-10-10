{
  fetchFromGitLab,
  stdenv,
  ncurses,
}:
stdenv.mkDerivation rec {
  pname = "pond";
  version = "1b74089f";

  src = fetchFromGitLab {
    owner = "alice-lefebvre";
    repo = pname;
    rev = version;
    hash = "sha256-xG2dQ0hzQMNGV2NreLzXQWeDE5QJc0j6A5JBXmSMavk=";
  };

  buildInputs = [ ncurses ];

  preBuild = ''
    mkdir --parents $out/bin
    cp --recursive --dereference $src/Makefile $out/

    cd $out
    substituteInPlace Makefile \
        --replace-fail "-lcurses" "-lncurses" \
        --replace-fail "pond.c" "$src/pond.c" \
        --replace-fail "cp bin/pond /usr/games/pond" ""
  '';

  postInstall = ''
    rm Makefile
  '';
}
