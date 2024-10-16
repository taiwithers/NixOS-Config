{
  fetchzip,
  stdenv,
  lib,
  pkgs,
  makeDesktopItem,
}:
let
  libpath = lib.makeLibraryPath (
    with pkgs;
    [
      xorg.libX11 # provides libX11.so.6
      xorg.libXext # probides libXext.so.6
      (lib.getLib gfortran.cc) # provides libgfortran.so.5 libstdc++.so.6
      zlib # provides libz.so.1
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "gaia";
  version = "2023A";
  distribution = "Ubuntu23";

  src = fetchzip {
    url = "https://ftp.eao.hawaii.edu/starlink/${version}/starlink-${version}-Linux-${distribution}.tar.gz";
    sha256 = "LDbPeKFntZT/2Flw3bX+TPkso8NihmezLyEL6h+YN20=";
  };

  postInstall =
    # bash
    ''
      # substituteInPlace $out/bin/gaia/gaia.sh \
      #                   --replace-warn "$HOME" "$XDG_CACHE_HOME"
      sed --in-place 's/\$HOME/\$XDG_CACHE_HOME/g' $out/bin/gaia/gaia.sh
    '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -pr * $out/
    runHook postInstall
  '';

  fixupPhase = ''
    chmod 755 $out/bin/*
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --add-rpath ${libpath} \
             --add-needed libX11.so.6 \
             --add-needed libstdc++.so.6 \
             --add-needed libz.so.1 \
             --add-needed libXext.so.6 \
             $out/bin/gaia/gaia_wish
  '';

  doInstallCheck = true;

  desktopItems = [
    (makeDesktopItem {
      desktopName = "gaia";
      name = "gaia";
      exec = "gaia";
      icon = "gaia_small_logo.gif";
    })
  ];
}
# no space:
# nix-store --delete /nix/store/*-gaia-2023A
