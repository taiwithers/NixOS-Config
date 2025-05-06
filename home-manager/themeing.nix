{
  config,
  pkgs,
  stylix,
  ...
}:
{
  imports = [ stylix.homeManagerModules.stylix ];

  xdg.configFile."sublime-text/Packages/User/Base16/theme.tmTheme".source = config.lib.stylix.colors {
    template = builtins.readFile (
      builtins.fetchurl {
        url = "https://raw.githubusercontent.com/chriskempson/base16-textmate/refs/heads/master/templates/default.mustache";
        sha256 = "sha256:0a82c8xhk7909grdnsmm0q91kyhml7xcgmzx5jpav2y4k99q3gvx";
      }
    );
    extension = ".tmTheme";
  };
  xdg.configFile."sublime-text/Packages/User/Preferences.sublime-settings".text =
    # JSON
    ''
      {
        "ignored_packages":
        [
          "Vintage",
        ],
        "font_size": 11,
        "color_scheme": "Packages/User/Base16/theme.tmTheme",
        "theme": "Adaptive.sublime-theme",
      }
    '';
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-ocean.yaml";
    fonts = rec {
      monospace.package = pkgs.intel-one-mono;
      monospace.name = "Intel One Mono";
      sansSerif.package = pkgs.open-sans;
      sansSerif.name = "Open Sans";
      serif.package = sansSerif.package;
      serif.name = sansSerif.name;
      sizes = {
        applications = 12;
        desktop = 12;
        popups = 10;
        terminal = 12;
      };
    };
    cursor = {
      package = pkgs.posy-cursors;
      name = "Posy_Cursor_Black";
      size = 32;
    };
    opacity = {
      applications = 0.8;
      desktop = 0.8;
      popups = 0.8;
      terminal = 0.0;
    };
    targets = {
      bat.enable = true;
      fzf.enable = true;
      gtk.enable = false; # doesn't follow breeze theme
      kde.enable = false; # requires wallpaper to be set
      kitty.enable = true;
      lazygit.enable = true;
      neovim = {
        enable = false;
        plugin = "base16-nvim";
        transparentBackground.main = false;
        transparentBackground.signColumn = false;
      };
      rofi.enable = false; # conflicts with rofi layout styling
      spicetify.enable = false;
      starship.enable = false; # haven't investigated
      vesktop.enable = true;
      vscode.enable = true;
      yazi.enable = true;
      zellij.enable = true;
    };
  };
}
