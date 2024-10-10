{ config, pkgs, ... }:
let
  bdconfigpath = "${config.common.configHome}/BetterDiscord";
  plugins = {
    PluginRepo = "https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/5a4507dbc7e463316481c062678b89045ba0fd14/Plugins/PluginRepo/PluginRepo.plugin.js";
    ThemeRepo = "https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/71638f8c19f8ee1157ea5cc7c5dae4ea0347e604/Plugins/ThemeRepo/ThemeRepo.plugin.js";
  };
in
{
  home.packages = [ pkgs.betterdiscordctl ];

  xdg.configFile =
    with pkgs.lib.attrsets;
    mapAttrs' (
      name: value:
      nameValuePair ("${bdconfigpath}/plugins/${name}.plugin.js") { source = builtins.fetchurl value; }
    ) plugins;

}
