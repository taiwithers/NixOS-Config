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
      revtex4-1
      standalone
      ;
  };
in {
  home.packages = [mytex];
}
