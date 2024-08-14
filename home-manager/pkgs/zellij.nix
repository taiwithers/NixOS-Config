{config, pkgs, app-themes,...}:{
    programs.zellij = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        theme = "base16";
        themes.base16 = with app-themes.palettes.zellij; {
          fg = "#${base05}";
          bg = "#${base02}";
          black = "#${base00}";
          red = "#${base08}";
          green = "#${base0B}";
          yellow = "#${base0A}";
          blue = "#${base0D}";
          magenta = "#${base0E}";
          cyan = "#${base0C}";
          white = "#${base05}";
          orange = "#${base09}";
        };
      };
    };
  }
