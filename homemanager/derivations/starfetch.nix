{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "starfetch";
  version = "d0aab03";

  src = fetchFromGitHub {
    owner = "Haruno19";
    repo = "starfetch";
    rev = version;
    hash = "sha256-HQxtEdfV+nENmhCVyl/RdciQFSbMIMtJCr5eIV1nA4k=";
  };

  preBuild = ''
    # create (writable) output directory
    mkdir --parents $out

    # create $BIN_DIR for makefile
    mkdir --parents $out/local/bin

    # copy source to output
    cp --recursive --dereference $src/* $out/

    # patch files
    substituteInPlace $(grep --recursive --files-with-matches "/usr" $out) --replace-fail "/usr" "$out"

    # move to output directory so correct makefile will be used
    cd $out
  '';
}
