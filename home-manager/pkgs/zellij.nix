{config, pkgs, app-themes,...}:{
    programs.zellij = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        # theme = "base16";
        themes.base16 = with app-themes.palettes.zellij; {
          fg = "#${base00}";
          bg = "#${base00}";
          black = "#${base00}";
          red = "#${base00}";
          green = "#${base00}";
          yellow = "#${base00}";
          blue = "#${base00}";
          magenta = "#${base00}";
          cyan = "#${base00}";
          white = "#${base00}";
          orange = "#${base00}";
        };
      };
    };
  }
