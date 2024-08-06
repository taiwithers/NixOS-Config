# https://discourse.nixos.org/t/nixos-options-to-configure-gnome-keyboard-shortcuts/7275/7
{custom-keyboard-shortcuts}: {
  dconf.settings = let
    inherit
      (builtins)
      length
      head
      tail
      listToAttrs
      genList
      ;
    globalPath = "org/gnome/settings-daemon/plugins/media-keys";
    # path = "${globalPath}/custom-keybindings";
    mkPath = id: "${globalPath}/custom${toString id}";
    isEmpty = list: length list == 0;
    mkSettings = settings: let
      checkSettings = {
        name,
        command,
        binding,
      } @ this:
        this;
      aux = i: list:
        if isEmpty list
        then []
        else let
          hd = head list;
          tl = tail list;
          name = mkPath i;
        in
          aux (i + 1) tl
          ++ [
            {
              name = mkPath i;
              value = checkSettings hd;
            }
          ];
      settingsList = aux 0 settings;
    in
      listToAttrs (
        settingsList
        ++ [
          {
            name = globalPath;
            value = {
              custom-keybindings = genList (i: "/${mkPath i}/") (length settingsList);
            };
          }
        ]
      );
  in
    mkSettings custom-keyboard-shortcuts;
}
