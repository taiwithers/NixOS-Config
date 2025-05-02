{
  niri,
  ...
}:
{
  imports = [ niri.homeModules.niri ];
  programs.niri.settings = {
    binds = {
      "Mod+Space".action.spawn = "rofi -show";
      "Mod+R".action.spawn = "rofi -show";
      "Mod+T".action.spawn = "kitty";
    };
    prefer-no-csd = true; # prefer SSD
    spawn-at-startup = [
      { command = [ "xwayland-satellite" ]; }
    ];
    environment = {
      DISPLAY = ":0";
    };

  };

}
