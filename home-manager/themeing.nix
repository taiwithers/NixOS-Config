{
  pkgs,
  stylix,
  ...
}:
{
  imports = [ stylix.homeManagerModules.stylix ];

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
      terminal = 0.5;
    };
    targets = {
      bat.enable = true;
      fzf.enable = true;
      gtk.enable = false; # doesn't follow breeze theme
      kde.enable = false; # requires wallpaper to be set
      kitty.enable = true;
      lazygit.enable = true;
      neovim.enable = true;
      rofi.enable = false; # conflicts with rofi layout styling
      spicetify.enable = true;
      vesktop.enable = true;
      vscode.enable = true;
      yazi.enable = true;
    };
  };
}
