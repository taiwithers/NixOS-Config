{config, pkgs, ...}:{
    home.packages = [pkgs.betterdiscordctl];

    xdg.configFile."BetterDiscord/Plugins/PluginRepo.plugin.js".source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/5a4507dbc7e463316481c062678b89045ba0fd14/Plugins/PluginRepo/PluginRepo.plugin.js";
        hash = "";
      };
  }
