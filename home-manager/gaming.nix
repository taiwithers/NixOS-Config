{
  pkgs,
  ...
}:{
home.packages = with pkgs; [
tetrio-desktop
mgba
protonup
rare
];

  # run steam with gpu
  xdg.dataFile."applications/steam.desktop".text = builtins.replaceStrings ["Exec="] ["Exec=nvidia-offload "] (builtins.readFile /run/current-system/sw/share/applications/steam.desktop);
# protonup
home.sessionVariables."STEAM_EXTRA_COMPAT_TOOLS_PATHS" = "\${HOME}/.steam/root/compatibilitytools.d";

  }
