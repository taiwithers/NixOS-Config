{config, pkgs, ...}:{
    home.packages = [pkgs.vesktop];

    xdg.configFile."vesktop/themes/thin.theme.css".source = ./thin.theme.css;
    xdg.configFile."vesktop/themes/hide-extras.theme.css".source = ./hide-extras.theme.css;
    xdg.configFile."vesktop/themes/custom-colours.theme.css".source = ./custom-colours.theme.css;
  }
