{
  config,
  pkgs,
  ...
}: {
  programs.bash.bashrcExtra = ''
    # GAIA
    export STARLINK_DIR=$(dirname $(dirname $(readlink $(which starversion))))
    shopt -u expand-aliases
    source $STARLINK_DIR/etc/profile
    shopt -s expand-aliases
  '';
}
