{ pkgs, nixcord, ... }:
{
  imports = [ nixcord.homeModules.nixcord ];
  # home.packages = [ pkgs.vesktop ];

  programs.nixcord = {
    enable = true;

    discord.enable = false;

    vesktop.enable = true;
    vesktop.package = pkgs.vesktop;

    config = {
      useQuickCss = true;
      enabledThemes = [ "stylix.theme.css" ];
      frameless = false;
      transparent = false;
      disableMinSize = true;
      plugins = {
        biggerStreamPreview.enable = true;
        callTimer.enable = true;
        clearURLs.enable = true;
        newGuildSettings.enable = true;
        noDevtoolsWarning.enable = true;
        noF1.enable = true;
        pinDMs.enable = true;
        volumeBooster.enable = true;
        webScreenShareFixes.enable = true;
        webRichPresence.enable = false;
      };

    };

    vesktopConfig = {
      minimizeToTray = "on";
      enabledThemes = [
        "stylix.theme.css"
        "thin.theme.css"
        "hide-extras.theme.css"
      ];
    };
  };

  xdg.configFile."vesktop/themes/thin.theme.css".source = ./thin.theme.css;
  xdg.configFile."vesktop/themes/hide-extras.theme.css".source = ./hide-extras.theme.css;
  xdg.configFile."vesktop/themes/custom-colours.theme.css".source = ./custom-colours.theme.css;

  # technically splashBackground should be tied to theme colours
  # xdg.configFile."vesktop/settings.json".text = ''
  #   {
  #       "minimizeToTray": "on",
  #       "discordBranch": "canary",
  #       "arRPC": true,
  #       "splashColor": "rgb(255, 255, 255)",
  #       "clickTrayToShowHide": true,
  #       "disableMinSize": true,
  #       "openLinksWithElectron": false,
  #       "spellCheckLanguages": [
  #           "en-GB",
  #           "en-CA",
  #           "en"
  #       ],
  #       "audio": {
  #           "onlySpeakers": false,
  #           "onlyDefaultSpeakers": false,
  #           "ignoreInputMedia": false,
  #           "ignoreDevices": false
  #       },
  #       "splashTheming": true,
  #       "splashBackground": "rgb(23, 23, 38)"
  #   }
  # '';
}
