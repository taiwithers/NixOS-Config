# build with nix-build --expr 'with import <nixpkgs> {}; callPackage ./ds9.nix {}'
{
  fetchzip,
  xorg,
  gcc,
  fontconfig,
  libxml2,
  stdenv,
  lib,
}: let
  libPath = lib.makeLibraryPath [
    xorg.libX11.out
    xorg.libXScrnSaver
    xorg.libXft.out
    (lib.getLib gcc.cc)
    fontconfig.lib
    libxml2.out
  ];
in
  stdenv.mkDerivation rec {
    pname = "ds9";
    version = "8.6b1";
    distribution = "ubuntu22x86";

    src = fetchzip {
      url = "https://ds9.si.edu/download/${distribution}/ds9.${distribution}.${version}.tar.gz";
      sha256 = "BFQfxIesSOCUI35mF5ADmV27TlO+WZvXjh1ULXcQlRA=";
    };

    buildInputs = [
      xorg.libX11.out
      xorg.libXScrnSaver
      xorg.libXft.out
      (lib.getLib gcc.cc)
      fontconfig.lib
      libxml2.out
    ];

    installPhase =
      /*
      bash
      */
      ''
        mkdir -p $out/bin
        cp -p * $out/bin
      '';

    fixupPhase =
      /*
      bash
      */
      ''
        chmod 755 $out/bin/ds9
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath ${libPath}   $out/bin/ds9
      '';
  }
