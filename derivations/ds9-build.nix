# build with nix-build --expr 'with import <nixpkgs> {}; callPackage ./ds9.nix {}'
# nix log /nix/store/r9clxfcvqbnvd4ph47wsbzi5ldvljah6-ds9-99aae07.drv
{
  fetchFromGitHub,
  # xorg,
  # gcc,
  # fontconfig,
  libxml2,
  stdenv,
  makeDesktopItem,
  copyDesktopItems,
  libXft,
  libX11,
  autoconf,
  perl,
  zlib,
  tcl,
  libxslt,
}:
let
  # libPath = lib.makeLibraryPath [
  #   xorg.libX11.out
  #   xorg.libXScrnSaver
  #   xorg.libXft.out
  #   (lib.getLib gcc.cc)
  #   fontconfig.lib
  #   libxml2.out
  # ];

  desktopItem = makeDesktopItem rec {
    name = "ds9";
    desktopName = name;
    exec = "ds9 %F";
    icon = "ds9";
  };

in
stdenv.mkDerivation rec {
  pname = "ds9";
  version = "99aae07";

  src = fetchFromGitHub {
    owner = "SAOImageDS9";
    repo = "SAOImageDS9";
    rev = version;
    hash = "sha256-j3u2r6Xhp1YF+kPtYj1iOVjMJO2K8Ep+qvQLzZyPt/Y=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    libxml2.dev
    libxml2
  ];

  buildInputs = [
    libX11
    perl
    autoconf
    zlib
    libXft
    # xorg.libX11.out
    # xorg.libXScrnSaver
    # xorg.libXft.out
    # (lib.getLib gcc.cc)
    # fontconfig.lib
    tcl
    libxslt
    libxml2
    libxml2.dev
  ];

  configureScript = "unix/configure";

  # buildPhase = ''
  #   runHook preBuild
  #
  #   cat Makefile
  #
  #   runHook postBuild
  # '';

  # not sure if this is necessary or if there's a way to indicate "just run make"
  # as a flag or something
  # installPhase = ''
  #   runHook preInstall
  #
  #   make
  #
  #   runHook postInstall
  # '';

  # installPhase =
  #   ''
  #     runHook preInstall

  #     mkdir -p $out/bin
  #     cp -p * $out/bin

  #     runHook postInstall
  #   '';

  # fixupPhase =
  #   ''
  #     runHook preFixup

  #     chmod 755 $out/bin/ds9
  #     patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
  #       --set-rpath ${libPath}   $out/bin/ds9

  #     runHook postFixup
  #   '';

  desktopItems = [ desktopItem ];
}
