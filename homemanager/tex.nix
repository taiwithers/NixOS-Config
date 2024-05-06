{
  config,
  pkgs,
  ...
}: let
  mytex = pkgs.texliveMinimal.withPackages (ps:
    with ps; [
      standalone
    ]);
in {
  home.packages = [mytex];
}
