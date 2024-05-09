# https://github.com/nix-community/home-manager/issues/3447#issuecomment-1328294558
{autostart-pkgs}: let
in {
  xdg.configFile = builtins.listToAttrs (map (pkg: {
      name = ".config/autostart/${pkg.pname}.desktop";
      value =
        if pkg ? desktopItem
        then {
          # Application has a desktopItem entry.
          # Assume that it was made with makeDesktopEntry, which exposes a
          # text attribute with the contents of the .desktop file
          text = pkg.desktopItem.text;
        }
        else {
          # Application does *not* have a desktopItem entry. Try to find a
          # matching .desktop name in /share/applications
          source = "${pkg}/share/applications/${pkg.pname}.desktop";
        };
    })
    autostart-pkgs);
}
