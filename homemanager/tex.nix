{
  config,
  pkgs,
  ...
}: let
  # for packages not included in texlive: https://github.com/NixOS/nixpkgs/issues/21334
  # what's in what scheme: https://tex.stackexchange.com/questions/500339/what-makes-up-each-tex-live-install-tl-scheme
  mytex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-small # small is required over minimal for pdflatex which can't be installed as a package
      derivative
      enumitem
      latexmk
      hyphenat
      revtex4-1 # for aastex
      siunitx
      standalone
      epsf # for graphics
      svn-prov # required macros
      astro
      ;
  };
in {
  home.packages = [mytex];
}
