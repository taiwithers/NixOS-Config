# build with nix-build --expr 'with import <nixpkgs> {}; callPackage ./color-oracle.nix {}'
{
  fetchFromGitHub,
  stdenv,
  jdk,
  ant,
  stripJavaArchivesHook,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "color-oracle";
  version = "523772c";
  distribution = "windows/java";
  src = fetchFromGitHub {
    owner = "nvkelso";
    repo = "color-oracle-java";
    rev = version;
    hash = "sha256-Neh7Nh2451FAbzMMVDbOKbn+HWPw99UMdFvKX8GutKQ=";
  };

  nativeBuildInputs = [
    ant
    jdk
    stripJavaArchivesHook
    makeWrapper
  ];

  preBuild = ''
    mkdir --parents $out
    cp --recursive --dereference $src/* $out/
    cd $out
    substituteInPlace "$out/nbproject/build-impl.xml" \
      --replace-fail "\''${javac.source}" "8" \
      --replace-fail "\''${javac.target}" "8"
  '';

  buildPhase = ''
    runHook preBuild
    ant
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # copy generated jar file(s) to an appropriate location in $out
    install -Dm644 dist/ColorOracle.jar $out/share/color-oracle/ColorOracle.jar

    # make binary wrapper to run with JRE
    mkdir -p $out/bin
    makeWrapper ${jdk}/bin/java $out/bin/ColorOracle \
      --add-flags "-cp $out/dist/ColorOracle.jar ika.colororacle.ColorOracle"

    runHook postInstall
  '';
}
