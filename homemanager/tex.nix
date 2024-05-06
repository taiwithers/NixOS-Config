{
  config,
  pkgs,
  ...
}: let
  # for packages not included in texlive: https://github.com/NixOS/nixpkgs/issues/21334
  
  mytex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-small # small is required over minimal for pdflatex which can't be installed as a package
      latexmk
      revtex4-1
      standalone
      dvips # for graphics
      ;
  };
in {
  home.packages = [mytex];
}
