{ pkgs, ... }:
{
  home.packages = [ pkgs.vesktop ];

  xdg.configFile."vesktop/themes/thin.theme.css".source = ./thin.theme.css;
  xdg.configFile."vesktop/themes/hide-extras.theme.css".source = ./hide-extras.theme.css;
  xdg.configFile."vesktop/themes/custom-colours.theme.css".source = ./custom-colours.theme.css;

  # technically splashBackground should be tied to theme colours
  xdg.configFile."vesktop/settings.json".text = ''
    {
        "minimizeToTray": "on",
        "discordBranch": "canary",
        "arRPC": true,
        "splashColor": "rgb(255, 255, 255)",
        "clickTrayToShowHide": true,
        "disableMinSize": true,
        "openLinksWithElectron": false,
        "spellCheckLanguages": [
            "en-GB",
            "en-CA",
            "en"
        ],
        "audio": {
            "onlySpeakers": false,
            "onlyDefaultSpeakers": false,
            "ignoreInputMedia": false,
            "ignoreDevices": false
        },
        "splashTheming": true,
        "splashBackground": "rgb(23, 23, 38)"
    }
  '';
}
