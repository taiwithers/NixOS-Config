{
  fetchFromGitHub,
  stdenv,
}:
let 
  sourceRelativeDirectory = "starfetch-src";
in 
stdenv.mkDerivation rec {
  pname = "starfetch";
  version = "d0aab03";

  src = fetchFromGitHub {
    owner = "Haruno19";
    repo = "starfetch";
    rev = version;
    hash = "sha256-HQxtEdfV+nENmhCVyl/RdciQFSbMIMtJCr5eIV1nA4k=";
  };

  makefile = "${sourceRelativeDirectory}/makefile";
  preBuild = let
    buildDirectory = "$out";
    sourceDirectory = "${buildDirectory}/${sourceRelativeDirectory}";
  in 
    # bash
    ''
      # create (writable) output directory
      mkdir --parents ${sourceDirectory}

      # copy source to output
      cp -r $src/* ${sourceDirectory}

      # patch files
      substituteInPlace $(grep --recursive --files-with-matches "/usr/local" $out) --replace-fail "/usr" "${sourceDirectory}/"
      substituteInPlace ${sourceDirectory}/makefile \
          --replace-fail "src/starfetch.cpp" "${sourceDirectory}/src/starfetch.cpp" \
          --replace-fail "./res/*" "${sourceDirectory}/res/*" \
          --replace-fail "cp -rf starfetch" "mv starfetch"

      # create $BIN_DIR for makefile
      mkdir --parents ${sourceDirectory}/local/bin

      # move to output directory so correct makefile will be used
      cd ${buildDirectory}
    '';

  postInstall = '' 
    cd $out
    cp -r starfetch-src/local/* .
    rm bin/starfetch
    ln -s $out/share/starfetch/starfetch $out/bin/starfetch
  '';

  postFixup = ''
    rm -rf starfetch-src
  '';

}
