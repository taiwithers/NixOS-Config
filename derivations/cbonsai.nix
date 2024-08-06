{
  fetchFromGitLab,
  stdenv,
  ncurses,
  pkg-config,
  scdoc,
}:
stdenv.mkDerivation rec {
  pname = "cbonsai";
  version = "4682ec7c";

  src = fetchFromGitLab {
    owner = "jallbrit";
    repo = pname;
    rev = version;
    hash = "sha256-NvxzN/KwI/QVR5AbWIFVfeDs2tEFC4iUWpdbcRB/VAc=";
  };
  nativeBuildInputs = [
    pkg-config
    scdoc
  ];
  buildInputs = [ncurses];
  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=$(out)"
  ];
}
