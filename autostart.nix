{
  config,
  pkgs,
  ...
}: let
  unstable = import <nixos-unstable> {};
  autostartPrograms = [pkgs.teams-for-linux unstable.copyq];
in {
  home.file = builtins.listToAttrs (map
    (pkg: {
      name = ".config/autostart/" + pkg.pname + ".desktop";
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
          # matching .desktop name in /share/apaplications
          source = pkg + "/share/applications/" + pkg.pname + ".desktop";
        };
    })
    autostartPrograms);
}
