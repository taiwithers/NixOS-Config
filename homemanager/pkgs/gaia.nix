{
  config,
  pkgs,
  ...
}: {
  programs.bash.bashrcExtra = ''
    # GAIA
    export STARLINK_DIR=$(dirname $(dirname $(readlink $(which starversion))))
    source $STARLINK_DIR/etc/profile
  '';
}
