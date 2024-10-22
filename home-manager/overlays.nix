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
    customScript = {name, runtimeInputs? [], file} : pkgs.writeShellApplication {
        name = name;
        runtimeInputs = runtimeInputs ++ [pkgs.coreutils];
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
    cbonsai = customDerivation "cbonsai";
    clean = customScript rec {
        name = "clean";
        runtimeInputs = with pkgs; [gnugrep gnused home-manager nix];
        file = name;
      };
    codium = super.vscodium-fhs;
    color-oracle = customDerivation "color-oracle";
    ds9 = customDerivation "ds9";
    fzf = unstable.fzf;
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
    kara = unstable.kara;
    kitty = unstable.kitty;
    klassy = customDerivation "klassy";
    neovim = unstable.neovim-unwrapped;
    nixfmt = unstable.nixfmt-rfc-style;
    nixshell = customScript rec {
        name = "nixshell";
        runtimeInputs = with pkgs; [
        nix
        bash
        ];
        file = name;
      };
    nixos-generations = customScript rec {
        name = "nixos-generations";
        runtimeInputs = with pkgs; [
        nix 
        jq
        ];
        file = name;
      };
    onlyoffice-desktopeditors = unstable.onlyoffice-desktopeditors;
    # onedrive = unstable.onedrive;
    onedrive = super.onedrive.overrideAttrs (oldAttrs: rec {
      version = "2.5.2";
      src = super.fetchFromGitHub {
        owner = "abraunegg";
        repo = oldAttrs.pname;
        rev = "v${version}";
        hash = "sha256-neJi5lIx45GsuwZPzzwwEm1bfrL2DFSysVkxa4fCBww=";
      };
    });
    # onedrivegui = unstable.onedrivegui;
    onedrivegui = super.onedrivegui.overridePythonAttrs (oldAttrs: rec {
      version = "1.1.1a";
      src = super.fetchFromGitHub {
        owner = "bpozdena";
        repo = "OneDriveGUI";
        rev = "v${version}";
        hash = "sha256-pcY1JOi74pePvkIMRuHv5mlE4F68NzuBLJTCtgjUFRw=";
      };
      postPatch =
        let
          setupPy = super.writeText "setup.py" ''
            from setuptools import setup
            setup(
              name='onedrivegui',
              version='${version}',
              scripts=[
                'src/OneDriveGUI.py',
              ],
            )
          '';
        in
        ''
          # Patch OneDriveGUI.py so DIR_PATH points to shared files location
          sed -i src/OneDriveGUI.py -e "s@^DIR_PATH =.*@DIR_PATH = '$out/share/OneDriveGUI'@"
          cp ${setupPy} ${setupPy.name}
        '';
    });
    plasma-panel-colorizer = unstable.plasma-panel-colorizer;
    pond = customDerivation "pond";
    realvnc-vnc-viewer = super.realvnc-vnc-viewer.overrideAttrs (oldAttrs: rec {
      src = super.requireFile rec {
        url = "https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-7.5.1-Linux-x64.rpm";
        hash = "sha256-Ull9iNi8NxB12YwEThWE0P9k1xOV2LZnebuRrVH/zwI="; # ${super.nix-prefetch} fetchurl --quiet --url '${url}' --option extra-experimental-features flakes
      };
    });
    search = customScript rec {
        name = "search";
        runtimeInputs = with pkgs; [nix-search-cli sd jq nix];
        file = "nix-search-wrapper";
      };
    starfetch = customDerivation "starfetch";
    sublime4 = unstable.sublime4;
    superfile = flake-inputs.superfile.packages.${system}.default;
    tofi = super.tofi.overrideAttrs (oldAttrs: rec {
      version = "1aa56b1";
      src = super.fetchFromGitHub {
        owner = "itshog";
        repo = super.tofi.pname;
        rev = version;
        hash = "sha256-KiSkb8HOzBnPyzQcHTyUmVixwpls3/o9BbDBkNWu71c=";
      };
    });
    trashy = super.trashy.override (old: {
      # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393/10
      rustPlatform = old.rustPlatform // {
        buildRustPackage =
          args:
          old.rustPlatform.buildRustPackage (
            args
            // rec {
              name = "${args.pname}-${version}";
              version = "7c48827";
              cargoHash = "sha256-iEUa6JLUH2m+8SclTNBzhCldnhbMpWb8ktkM4rU3hmw=";
              src = super.fetchFromGitHub {
                owner = "oberblastmeister";
                repo = "trashy";
                rev = version;
                hash = "sha256-1pxmeXUkgAITouO0mdW6DgZR6+ai2dax2S4hV9jcJLM=";
              };
              preFixup = ''
                installShellCompletion --cmd trashy \
                    --bash <($out/bin/trashy completions bash)
              '';
            }
          );
      };
    });
    vimPlugins =
      super.vimPlugins
      // {
        hmts-nvim = unstable.vimPlugins.hmts-nvim;
      }
      // builtins.mapAttrs (name: value: (githubVimPlugin value)) {
        auto-hlsearch-nvim = {
          author = "asiryk";
          repo = "auto-hlsearch.nvim";
          rev = "7750206";
          hash = "sha256-SWsefzaLn5mnVfZcO2rEGiS1tuuV28S3kk09l0QAedM=";
        };
        f-string-toggle-nvim = {
          author = "roobert";
          repo = "f-string-toggle.nvim";
          rev = "4e2ad79";
          hash = "sha256-IMMq4cklHxrhfHALcCamMWT4ekBqOMtkiAUXh8YlaM0=";
        };
        hardtime-nvim = {
          repo = "hardtime.nvim";
          author = "m4xshen";
          rev = "6513bf4";
          hash = "sha256-O/+ZPHuEbTkRQq1kUxb3VzVlb3YWr+QkFOay838Vomw= ";
        };
        helpview-nvim = {
          author = "OXY2DEV";
          repo = "helpview.nvim";
          rev = "857aec1";
          hash = "sha256-x5ZV/1LKrxhQWsxsJwrIfD7BogKO7H2GKzDt3PABEh8=";
        };
        hmts-nvim = {
          author = "calops";
          repo = "hmts.nvim";
          rev = "v1.2.4";
          hash = "sha256-8FJlLw5LApQs7S8xEh2UE9wdYCAweZTbvgozCGPfQJc=";
        };
        modes-nvim = {
          author = "mvllow";
          repo = "modes.nvim";
          rev = "326cff3";
          hash = "sha256-z1XD0O+gG2/+g/skdWGC64Zv4dXvvhWesaK/8DcPF/E=";
        };
        nvim-treesitter = rec {
          author = repo;
          repo = "nvim-treesitter";
          rev = "585860a";
          hash = "sha256-cYpPXuZpvEOEnJlDucCh/E8Dx0Gl479yrECon/nwpCg=";
        };
        precognition-nvim = {
          author = "tris203";
          repo = "precognition.nvim";
          rev = "8a81c31";
          hash = "sha256-w+GniyMlA2AAumuACNlEkJLYxNU1W5XLww37yyRJ0PQ=";
        };
        tip-nvim = {
          author = "TobinPalmer";
          repo = "Tip.nvim";
          rev = "7e87517";
          hash = "sha256-9+YjOm2gmTIK6MmAqaAQ5M1IgMX0u5xSLmO+yWtaadk=";
        };
        treesitter-parser-query = {
          author = "tree-sitter-grammars";
          repo = "tree-sitter-query";
          rev = "f767fb0";
          hash = "sha256-snr0ze1VCaAf448mHkrB9qbWTMvjSlPdVl2VtesMIHI=";
        };
        treesitter-parser-vimdoc = {
          author = "neovim";
          repo = "tree-sitter-vimdoc";
          rev = "2249c44";
          hash = "sha256-v+XSWGm2Wdn9/rxNFMqXYACkGn6AvxZdxkClLuKnWGU=";
        };
        which-key-nvim = {
          author = "folke";
          repo = "which-key.nvim";
          rev = "bfec3d6";
          hash = "sha256-FY0KM0F2keMCqB5QhwfGS4w2wQOOeCXgZEa3U7Q1Bek=";
        };
      };
    zotero = unstable.zotero-beta;
  }
)
