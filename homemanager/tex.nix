{
  config,
  pkgs,
  ...
}: let
  mytex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-small # small is required over minimal for pdflatex which can't be installed as a package
      latexmk
      standalone
      revtex
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
