# requires --impure
pkg:
if builtins.hasAttr "desktopItem" pkg
then "${pkg.pname}.desktop"
else let
  # search for any files in the pkg.outPath/share/applications directory, catch for directory not existing
  directory = "${pkg}/share/applications";
  fileList =
    if builtins.pathExists directory
    then builtins.attrNames (builtins.readDir directory)
    else [];
in
  if builtins.length fileList > 0
  then builtins.elemAt fileList 0
  else null
