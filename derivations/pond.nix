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
    cp --recursive --dereference $src/* $out/
    cd $out
    substituteInPlace Makefile --replace-fail "-lcurses" "-lncurses"
    substituteInPlace Makefile --replace-fail "bin/pond" "$out/bin/pond"
    substituteInPlace Makefile --replace-fail "rm -f /usr/local/games/pond #old location" ""
    substituteInPlace Makefile --replace-fail "/usr/games/pond" "$out/pond"
    substituteInPlace Makefile --replace-fail "rmdir bin" "rmdir $out/bin"
  '';
}
