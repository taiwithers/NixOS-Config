{
  config,
  pkgs,
  ...
}: let
  mytex = pkgs.texliveMinimal.withPackages (ps:
    with ps; [
      latexmk
      standalone
    ]);
in {
  home.packages = [mytex];
}
