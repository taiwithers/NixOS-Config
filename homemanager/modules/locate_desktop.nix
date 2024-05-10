pkg:
if builtins.hasAttr "desktopItem" pkg
then "${pkg.pname}.desktop"
else builtins.elemAt (builtins.attrNames (builtins.readDir "${pkg.outPath}/share/applications")) 0
