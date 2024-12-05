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
        xelatex-dev # for nbconvert
        tcolorbox # for listings (in nbconvert)
        environ # nbconvert
        pdfcol # nbconvert
        eurosym # nbconvert
        iftex
        ucs
        latex-uni8
        fontspec
        unicode-math
        fancyvrb
        grffile
        adjustbox
        titling
        booktabs
        soul
        parskip
        rsfs # math font
        ;
    };
    kdePackages = super.kdePackages // {
      kara = super.kara;
      klassy = customDerivation "klassy";
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
      name = "nixos-generations";
      runtimeInputs = with pkgs; [
        nix
        jq
      ];
      file = name;
    };
    onedrive = unstable.onedrive;
    pond = customDerivation "pond";
    realvnc-vnc-viewer = super.realvnc-vnc-viewer.overrideAttrs (oldAttrs: rec {
      src = super.requireFile rec {
        url = "https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-7.5.1-Linux-x64.rpm";
        hash = "sha256-Ull9iNi8NxB12YwEThWE0P9k1xOV2LZnebuRrVH/zwI="; # ${super.nix-prefetch} fetchurl --quiet --url '${url}' --option extra-experimental-features flakes
      };
    });
#    rofi-wayland-unwrapped = super.rofi-wayland-unwrapped.overrideAttrs (oldAttrs: rec {
#      version = "93ad86d";
#      src = super.fetchFromGitHub {
#        owner = "lbonn";
#        repo = "rofi";
#        rev = version;
#        fetchSubmodules = true;
#        sha256 = "sha256-ipvG75snR39dziidFOb8wwgW2vL4ZIlcP1EWvYEqpP0=";
#      };
#    });
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
