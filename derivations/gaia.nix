{
  fetchzip,
  stdenv,
  lib,
  pkgs,
  makeDesktopItem,
  copyDesktopItems,
  coreutils,
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
  version = "2025A";
  distribution = "Ubuntu25";

  src = fetchzip {
    url = "https://ftp.eao.hawaii.edu/starlink/${version}/starlink-${version}-Linux-${distribution}.tar.gz";
    sha256 = "sha256-umaX0Rk/wxrqDZ6HlVxNIDE8jIrFr+Amt5ndlNsRbkw=";
  };

  installPhase = ''
    runHook preInstall

    # mkdir -p $out/
    # cp -pr * $out/

    mkdir -p $out/bin/gaiabin
    cp -pr bin/gaia/* $out/bin/gaiabin
    cp -pr lib $out

    substituteInPlace $out/bin/gaiabin/gaia.sh --replace-warn "$HOME" "$XDG_CACHE_HOME"

    substituteInPlace $out/lib/tclutil2.1.0/FileSelect.tcl --replace-warn "/bin/ls" "${coreutils}/bin/ls"

    ln -s $out/bin/gaiabin/gaia.sh $out/bin/gaia

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    chmod 755 $out/bin/*
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --add-rpath ${libpath} \
             --add-needed libX11.so.6 \
             --add-needed libstdc++.so.6 \
             --add-needed libz.so.1 \
             --add-needed libXext.so.6 \
             $out/bin/gaiabin/gaia_wish

    runHook postFixup
  '';

  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      desktopName = "gaia";
      name = "gaia";
      exec = "gaia";
      # icon = "$out/lib/gaia4.4.9/gaia_small_logo.gif";
    })
  ];
}
# no space:
# nix-store --delete /nix/store/*-gaia-2023A
