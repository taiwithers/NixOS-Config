{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.gaia];
  home.sessionVariables."STARLINK_DIR" = "${pkgs.gaia}";

  programs.bash.bashrcExtra = ''
    # GAIA
    shopt -u expand_aliases
    source $STARLINK_DIR/etc/profile
    shopt -s expand_aliases
  '';
}
