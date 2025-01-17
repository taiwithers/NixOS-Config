{ config, pkgs, ... }:
let
  latex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      collection-basic
      collection-latex
      collection-latexrecommended
      aastex # Macros for Manuscript Preparation for AAS Journals
      astro # planetary symbols
      babel-english # Babel support for English
      biber # biblatex backend
      cm-super # cm fonts
      derivative # Nice and easy derivatives
      dvipng # DVI to PNG converter
      enumitem # Control layout of itemize, enumerate, description
      epsf # macros for EPS files
      helvetic # URW 'Base 35' font pack for LaTeX
      hyphen-english # English hyphenation patterns.
      hyphenat # Disable/enable hypenation
      latexmk # default compiler for vimtex
      layouts # for printing \textwidth etc
      lipsum
      lm # latin moden fonts
      metafont # mf command line util for fonts
      multirow # Create tabular cells spanning multiple rows
      pgf # tikz - Create PostScript and PDF graphics in TeX
      physunits # Macros for commonly used physical units
      revtex4-1 # revtex gives revtex 4.2 which isn't accepted by aastex
      siunitx # A comprehensive (SI) units package
      standalone # Compile TeX pictures stand-alone or as part of a document
      svn-prov # required macros (for who??)
      synctex # engine-level feature synchronizing output and source
      tikz-ext # libraries (which?)
      tikzscale # resize pictures while respecting text size
      tikztosvg
      times # times new roman font
      type1cm # arbitrary font sizing
      ulem # underlining
      upquote # Show "realistic" quotes in verbatim
      wrapfig # Produces figures which text can flow around
      xelatex-dev # for nbconvert
      tcolorbox # for listings (in nbconvert)
      environ # nbconvert - A new interface for environments in LaTeX
      pdfcol # nbconvert - Macros for maintaining colour stacks under pdfTeX
      eurosym # nbconvert - Metafont and macros for Euro sign
      iftex # allow checking what compiler is being used
      ucs # utf8
      latex-uni8
      fontspec # font selection
      unicode-math
      fancyvrb # verbatim stuff
      grffile # Extended file name support for graphics (legacy package)
      adjustbox # Graphics package-alike macros for "general" boxes
      titling # Control over the typesetting of the maketitle command
      booktabs # Publication quality tables in LaTeX
      soul # hyphenation for letterspacing, underlining, and more
      parskip # Layout with zero parindent, non-zero parskip
      rsfs # math font
      sectsty # custom section headers
      xcolor # Driver-independent color extensions for LaTeX and pdfLaTeX
      tocloft # table of contents control
      threeparttable # Tables with captions and notes all the same width
      threeparttablex # Notes in longtables
      moreverb # extended verbatim
      cases # Numbered cases environment
      boxedminipage # Framed minipages of a specified total width (text and frame combined)
      changebar # Generate changebars in LaTeX documents
      changepage # Margin adjustment and detection of odd/even pages
      acronym # Expand acronyms at least once
      bigfoot # Footnotes for critical editions - contains 'suffix' which acronym relies on ?
      xstring # String manipulation for (La)TeX
      subfigure # subfigures and lists of figures/tables
      wasysym # some kind of font support? needed for thesis
      wasy # same as wasysym
      ;
  };
in
{
  home.packages =
    with pkgs;
    [
      pdf2svg # for eps file preview
    ]
    ++ [ latex ];

  home.shellAliases."compiletex" = "latexmk --auxdir=\"aux\" --gg --pdflatex --silent";
}
