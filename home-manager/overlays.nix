{
  pkgs,
  flake-inputs,
  system,
  ...
}:
(
  self: super:
  let
    customDerivation = fname: pkgs.callPackage (./. + "/../derivations/${fname}.nix") { };
    customScript =
      {
        name,
        runtimeInputs ? [ ],
        file,
      }:
      pkgs.writeShellApplication {
        name = name;
        runtimeInputs = runtimeInputs ++ [ pkgs.coreutils ];
        text = builtins.readFile (../scripts + "/${file}.sh");
      };
    githubVimPlugin =
      {
        author,
        repo,
        rev,
        hash ? "",
      }:
      (pkgs.vimUtils.buildVimPlugin {
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
  in
  {
    agenix = flake-inputs.agenix.packages.${system}.default;
    brightness-control = customScript rec {
      name = "brightness-control";
      runtimeInputs = [ pkgs.brightnessctl ];
      file = name;
    };
    cbonsai = customDerivation "cbonsai";
    clean = customScript rec {
      name = "clean";
      runtimeInputs = with pkgs; [
        gnugrep
        gnused
        home-manager
        nix
      ];
      file = name;
    };
    codium = super.vscodium-fhs;
    color-oracle = customDerivation "color-oracle";
    diff-hm-generations = customScript rec {
      name = "diff-hm-generations";
      runtimeInputs = with pkgs; [
        gnused
        home-manager
        nix
        sd
        nvd
      ];
      file = "diff-generations";
    };
    ds9 = customDerivation "ds9";
    gaia = customDerivation "gaia";
    get-package-path = customScript {
      name = "get-package-path";
      runtimeInputs = [ pkgs.which ];
      file = "get-package-dir";
    };
    latex = super.texlive.combine {
      inherit (super.texlive)
        collection-basic
        collection-latex
        collection-latexrecommended
        aastex # Macros for Manuscript Preparation for AAS Journals
        astro # planetary symbols
        babel-english # Babel support for English
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
    karp = unstable.karp;
    kdePackages = super.kdePackages // {
      kara = super.kara;
      klassy = super.nur.repos.shadowrz.klassy-qt6.overrideAttrs (oldAttrs: rec {
            version = "58c6ad5";
            src = super.fetchFromGitHub {
                owner = "paulmcauley";
                repo = oldAttrs.pname;
                rev = version;
                hash = "sha256-B7nQVok/3uCskGykqEoaZcpzpIk15tT7qDPG3qCbn4Q=";
              };
        }); #customDerivation "klassy";
    };
    nixfmt = super.nixfmt-rfc-style;
    nixshell = customScript rec {
      name = "nixshell";
      runtimeInputs = with pkgs; [
        nix
        bash
      ];
      file = name;
    };
    generations = customScript rec {
      name = "generations";
      runtimeInputs = with pkgs; [
        nix
        jq
      ];
      file = "nixos-generations";
    };
    onedrive = unstable.onedrive;
    pond = customDerivation "pond";
    rofi-calc = super.rofi-calc.override {
      rofi-unwrapped = self.rofi-wayland-unwrapped;
    };
    search = customScript rec {
      name = "search";
      runtimeInputs = with pkgs; [
        nix-search-cli
        sd
        jq
        nix
      ];
      file = "nix-search-wrapper";
    };
    starfetch = customDerivation "starfetch";
    vesktop = super.vesktop.overrideAttrs (oldAttrs: {
      srcs = [
        oldAttrs.src
        ../derivations/vesktop/discord.tar.gz
      ];
      sourceRoot = "source"; # move into git repo
      patches = oldAttrs.patches ++ [
        ../derivations/vesktop/shiggy.patch
        ../derivations/vesktop/icon.patch
      ];
      postInstall = ''
        cp ../discord.png $out/opt/Vesktop/resources/
        cp -r static/views $out/opt/Vesktop/resources/
      '';
      desktopItems = super.makeDesktopItem rec {
        name = "Discord";
        desktopName = name;
        exec = "nvidia-offload vesktop %U";
        icon = "vesktop";
        startupWMClass = name;
      };
    });
    vimPlugins =
      super.vimPlugins
      // {
        snacks-nvim = unstable.vimPlugins.snacks-nvim;
      }
      // builtins.mapAttrs (name: value: (githubVimPlugin value)) {
        f-string-toggle-nvim = {
          author = "roobert";
          repo = "f-string-toggle.nvim";
          rev = "4e2ad79";
          hash = "sha256-IMMq4cklHxrhfHALcCamMWT4ekBqOMtkiAUXh8YlaM0=";
        };
        modes-nvim = {
          author = "mvllow";
          repo = "modes.nvim";
          rev = "326cff3";
          hash = "sha256-z1XD0O+gG2/+g/skdWGC64Zv4dXvvhWesaK/8DcPF/E=";
        };
      };
  }
)
