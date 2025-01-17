# build with nix-build --expr 'with import <nixpkgs> {}; callPackage ./ds9.nix {}'
{
  fetchzip,
  xorg,
  gcc,
  fontconfig,
  libxml2,
  stdenv,
  makeDesktopItem,
  copyDesktopItems,
  lib,
}:
let
  libPath = lib.makeLibraryPath [
    xorg.libX11.out
    xorg.libXScrnSaver
    xorg.libXft.out
    (lib.getLib gcc.cc)
    fontconfig.lib
    libxml2.out
  ];

  desktopItem = makeDesktopItem rec {
    name = "ds9";
    desktopName = name;
    exec = "ds9 %F";
    icon = "ds9";
  };

in
stdenv.mkDerivation rec {
  pname = "ds9";
  version = "8.7b1";
  distribution = "ubuntu24x86";
  src = fetchzip {
    url = "https://ds9.si.edu/download/${distribution}/ds9.${distribution}.${version}.tar.gz";
    sha256 = "lBRU+1pZ+PH5aQVwNPJgFGuJllwNATO/4Uu9vmXEpK8=";
  };

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [
    xorg.libX11.out
    xorg.libXScrnSaver
    xorg.libXft.out
    (lib.getLib gcc.cc)
    fontconfig.lib
    libxml2.out
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -p * $out/bin

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    chmod 755 $out/bin/ds9
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath}   $out/bin/ds9

    runHook postFixup
  '';

  desktopItems = [ desktopItem ];
}
