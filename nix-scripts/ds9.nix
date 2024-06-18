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
  stdenv.mkDerivation {
    name = "ds9";

    src = fetchzip {
      url = "https://ds9.si.edu/download/ubuntu22x86/ds9.ubuntu22x86.8.5.tar.gz";
      sha256 = "GwmY+JPGG8PnCfnw30zU6CTE0zboNK3ZGGZhtPoyeq8=";
    };

    phases = ["unpackPhase" "installPhase" "fixupPhase"];

    buildInputs = [
      xorg.libX11.out
      xorg.libXScrnSaver
      xorg.libXft.out
      (lib.getLib gcc.cc)
      fontconfig.lib
      libxml2.out
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp -p * $out/bin
    '';

    fixupPhase = ''
      chmod 755 $out/bin/ds9
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath ${libPath}   $out/bin/ds9
    ''; 
  }
