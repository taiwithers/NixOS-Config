{
  config,
  pkgs,
  ...
}: let
  # small is required over minimal for pdflatx which can't be installed as a package
  mytex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-small
      latexmk
      standalone
      ;
  };
  # mytex = pkgs.texliveSmall.withPackages (ps:
  #   with ps; [
  #     latexmk
  #     standalone
  #   ]);
in {
  home.packages = [mytex];
}
