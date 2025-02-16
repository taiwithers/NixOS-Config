{ pkgs, ... }:
{
  environment.sessionVariables."GTK_USE_PORTAL" = 1;
  environment.sessionVariables."KWIN_DRM_DISABLE_TRIPLE_BUFFERING" = 1;
  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    theme = "where_is_my_sddm_theme";
    # autoLogin.relogin = true;
    settings = {
      General = {
        InputMethod = null;
      };
      # Theme = {
      #   CursorTheme = "Posy_Cursors_Black";
      # };
    };
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
    khelpcenter
    # konsole
    kwalletmanager
    okular
  ];
}
