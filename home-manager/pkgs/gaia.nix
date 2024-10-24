{
  config,
  pkgs,
  ...
}:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "gaia";
      runtimeInputs = [ pkgs.gaia ];
      text = ''
        "$STARLINK_DIR/bin/gaia/gaia.sh"
      '';
    })
  ];
  home.sessionVariables."STARLINK_DIR" = "${pkgs.gaia}";

}
