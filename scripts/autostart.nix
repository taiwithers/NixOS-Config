# https://github.com/nix-community/home-manager/issues/3447#issuecomment-1328294558
{
  config,
  autostart-pkgs,
}: let
  locateDesktop = import ./locate-desktop.nix;
in {
  xdg.configFile = builtins.listToAttrs (map (pkg: {
      name = "${config.xdg.configHome}/autostart/${pkg.pname}.desktop";
      value = {source = "${pkg}/share/applications/${locateDesktop pkg}";};
      # if pkg ? desktopItem
      # then {
      #   # Application has a desktopItem entry.
      #   # Assume that it was made with makeDesktopEntry, which exposes a
      #   # text attribute with the contents of the .desktop file
      #   text = pkg.desktopItem.text;
      # }
      # else {
      #   # Application does *not* have a desktopItem entry. Try to find a
      #   # matching .desktop name in /share/applications
      #   source = "${pkg}/share/applications/${pkg.pname}.desktop";
      # };
    })
    autostart-pkgs);
}
