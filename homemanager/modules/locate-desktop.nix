# requires --impure
pkg:
if builtins.hasAttr "desktopItem" pkg
then "${pkg.pname}.desktop"
else let
  # search for any files in the pkg.outPath/share/applications directory, catch for directory not existing
  filelist =
    builtins.tryEval (builtins.attrNames (builtins.readDir "${pkg}/share/applications"));
in
  if filelist.success && builtins.length filelist.value > 0
  then builtins.elemAt filelist.value 0
  else null
