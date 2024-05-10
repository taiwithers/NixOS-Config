# requires --impure
pkg: let
  lib = import <nixpkgs/lib>;
in
  if builtins.hasAttr "desktopItem" pkg
  then "${pkg.pname}.desktop"
  else let
    # search for any files in the pkg.outPath/share/applications directory, catch for directory not existing
    directory = "${pkg}/share/applications"; # directory to search
    fileIsDesktop = filename: lib.strings.hasSuffix ".desktop" filename;
    fileList =
      if builtins.pathExists directory
      then builtins.filter fileIsDesktop (builtins.attrNames (builtins.readDir directory)) # get files in directory ending in ".desktop"
      else [];
  in
    if builtins.length fileList > 0
    then builtins.elemAt fileList 0 # return first .desktop file found (if any)
    else throw "Cannot locate .desktop file for package ${pkg.pname}"
# throw error if none found

