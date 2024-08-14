{pkgs, flake-inputs, system, ...}: (self: super: let
  customDerivation = fname: pkgs.callPackage (./. + "/../derivations/${fname}.nix") {};
  githubVimPlugin = {
    author,
    repo,
    rev,
    hash ? "",
  }: (pkgs.vimUtils.buildVimPlugin {
    pname = repo;
    version = rev;
    src = pkgs.fetchFromGitHub {
      owner = author;
      repo = repo;
      rev = rev;
      hash = hash;
    };
  });
  unstable = self.unstable;
in {
	agenix = flake-inputs.agenix.packages.${system}.default;
  cbonsai = customDerivation "cbonsai";
  codium = super.vscodium-fhs;
  color-oracle = customDerivation "color-oracle";
  ds9 = customDerivation "ds9";
  fzf = unstable.fzf;
  gaia = customDerivation "gaia";
  latex = super.texlive.combine {
    inherit
      (super.texlive)
      collection-basic
      collection-latex
      collection-latexrecommended
      aastex
      astro # planetary symbols
      babel-english
      cm-super # cm fonts
      derivative
      dvipng
      enumitem
      epsf
      helvetic
      hyphen-english
      hyphenat
      # latexmk
      
      layouts # for printing \textwidth etc
      lipsum
      lm # latin moden fonts
      metafont # mf command line util for fonts
      multirow
      pgf # tikz
      physunits
      revtex4-1 # revtex gives revtex 4.2 which isn't accepted by aastex
      siunitx
      standalone
      svn-prov # required macros (for who??)
      synctex # engine-level feature synchronizing output and source
      tikz-ext # libraries (which?)
      tikzscale # resize pictures while respecting text size
      tikztosvg
      times # times new roman font
      type1cm # arbitrary font sizing
      ulem # underlining
      upquote # Show "realistic" quotes in verbatim
      wrapfig
      ;
  };
  neovim = unstable.neovim-unwrapped;
  nixfmt = unstable.nixfmt-rfc-style;
  pond = customDerivation "pond";
  starfetch = customDerivation "starfetch";
  superfile = flake-inputs.superfile.packages.${system}.default;
  # texpresso = unstable.texpresso;
  vimPlugins =
    super.vimPlugins
    // builtins.mapAttrs (name: value: (githubVimPlugin value)) {
      precognition-nvim = {
        repo = "precognition.nvim";
        author = "tris203";
        rev = "2a566f0";
        hash = "sha256-XLcyRB4ow5nPoQ0S29bx0utV9Z/wogg7c3rozYSqlWE=";
      };
      modes-nvim = {
        author = "mvllow";
        repo = "modes.nvim";
        rev = "326cff3";
        hash = "sha256-z1XD0O+gG2/+g/skdWGC64Zv4dXvvhWesaK/8DcPF/E=";
      };
      which-key-nvim = {
        repo = "which-key.nvim";
        rev = "6c1584e";
        author = "folke";
        hash = "sha256-nv9s4/ax2BoL9IQdk42uN7mxIVFYiTK+1FVvWDKRnGM=";
      };
      tip-nvim = {
        repo = "Tip.nvim";
        author = "TobinPalmer";
        rev = "7e87517";
        hash = "sha256-9+YjOm2gmTIK6MmAqaAQ5M1IgMX0u5xSLmO+yWtaadk=";
      };
      f-string-toggle-nvim = {
        repo = "f-string-toggle.nvim";
        author = "roobert";
        rev = "4e2ad79";
        hash = "sha256-IMMq4cklHxrhfHALcCamMWT4ekBqOMtkiAUXh8YlaM0=";
      };
      auto-hlsearch-nvim = {
        repo = "auto-hlsearch.nvim";
        author = "asiryk";
        rev = "8f28246";
        hash = "sha256-AitkdtKoKNAURrEZuQU/VRLj71qDlI4zwL+vzXUJzew=";
      };
      helpview-nvim = {
        repo = "helpview.nvim";
        author = "OXY2DEV";
        rev = "7c24a92";
        hash = "sha256-V681TrMpOKuutUZ3n84W1z/y0iSz2SkarsZmhz5rI7w=";
      };
      hardtime-nvim = {
        repo = "hardtime.nvim";
        author = "m4xshen";
        rev = "91c6be1";
        hash = "sha256-pLJShpbqmJbY3ThQuGmUfgsxijSADJrqpGYLE+KAcUQ=";
      };
    };
  zotero = unstable.zotero-beta;
})
