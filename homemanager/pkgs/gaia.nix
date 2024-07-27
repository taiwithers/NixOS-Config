{ config, pkgs, ... }:
{
  home.packages = [pkgs.gaia];
  programs.bash.bashrcExtra = ''
    # GAIA
    export STARLINK_DIR=$(dirname $(dirname $(readlink $(which starversion))))
    shopt -u expand_aliases
    source $STARLINK_DIR/etc/profile
    shopt -s expand_aliases
  '';
}
