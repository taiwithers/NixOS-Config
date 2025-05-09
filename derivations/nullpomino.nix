{
  fetchzip,
  jre, 
  stdenv,
  makeWrapper,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "nullpomino";
  version = "7.5.0";

  src = fetchzip {
    url = "https://github.com/nullpomino/nullpomino/releases/download/v${version}/NullpoMino${version}_linux.tar.gz";
    hash = "sha256-lcE4FAUJIKGYiM2+OHhph95+SWQ9fyfgzVWEgZlnWlg=";
  };

  nativeBuildInputs = [
    jre
    makeWrapper
  ];

  installPhase = ''
    mkdir --parents $out/bin
    # cp $src/play_swing $out/bin/nullpomino
    
    install -Dm644 $src/NullpoMino.jar $out/share/nullpomino/NullpoMino.jar

    makeWrapper ${jre}/bin/java $out/bin/nullpomino --add-flags "-cp $out/share/nullpomino/NullpoMino.jar mu.nu.nullpo.gui.swing.NullpoMinoSwing"

  '';

  dontBuild = true;

  meta = {
    description = "An action puzzle game";
    homepage = "https://github.com/nullpomino/nullpomino";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [  ];
  };
}
