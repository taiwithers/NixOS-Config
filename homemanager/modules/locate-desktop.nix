# requires --impure
pkg:
if builtins.hasAttr "desktopItem" pkg
then "${pkg.pname}.desktop"
else let
  filelist = builtins.attrNames (builtins.readDir "${pkg}/share/applications");
in
  if builtins.length filelist == 0
  then null
  else builtins.elemAt filelist 0
