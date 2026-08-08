_:
(
  self: super:
  let
    customDerivation = fname: super.callPackage (./. + "/./derivations/${fname}.nix") { };
    customScript =
      {
        name,
        runtimeInputs ? [ ],
        file,
      }:
      super.writeShellApplication {
        inherit name runtimeInputs;
        text = builtins.readFile (./scripts + "/${file}.sh");
      };
    githubVimPlugin =
      {
        author,
        repo,
        rev,
        hash ? "",
      }:
      (super.vimUtils.buildVimPlugin {
        pname = repo;
        version = rev;
        src = super.fetchFromGitHub {
          owner = author;
          inherit repo;
          inherit rev;
          inherit hash;
        };
      });
    inherit (self) unstable;
  in
  {
    battery-scripts = customScript rec {
      name = "battery-scripts";
      runtimeInputs = [
        self.acpi
        self.jq
        self.libnotify
      ];
      file = name;
    };
    brightness-control = customScript rec {
      name = "brightness-control";
      runtimeInputs = [
        self.brightnessctl
        self.libnotify
        self.gawk
      ];
      file = name;
    };
    cbonsai = customDerivation "cbonsai";
    clean = customScript rec {
      name = "clean";
      runtimeInputs = with super; [
        gnused
        home-manager
        nix
        trash-cli
        sd
      ];
      file = name;
    };
    codium = super.vscodium-fhs.overrideAttrs (_oldAttrs: {
      pname = "codium";
      desktopItems = super.makeDesktopItem rec {
        name = "VSCodium";
        desktopName = name;
        exec = "codium %F";
        icon = "vscodium";
        startupWMClass = name;
      };
    });
    diff-nix-generations = customScript {
      name = "diff-nix-generations";
      runtimeInputs = with super; [
        gnused
        home-manager
        nix
        sd
        nvd
        jq
      ];
      file = "diff-generations";
    };
    ds9 = customDerivation "ds9";
    gaia = customDerivation "gaia";
    heroic = super.heroic.override {
      extraPkgs = _pkgs: [ super.gamemode ];
    };
    nixos-generations = customScript {
      name = "generations";
      runtimeInputs = with super; [
        nix
        jq
      ];
      file = "nixos-generations";
    };
    get-package-path = customScript {
      name = "get-package-path";
      runtimeInputs = [ super.which ];
      file = "get-package-dir";
    };
    kdePackages = super.kdePackages // {
      inherit (super) kara darkly;
      klassy = customDerivation "klassy";
      inherit (unstable.kdePackages) krohnkite;
    };
    nbpreview = customDerivation "nbpreview";
    nixshell = customScript rec {
      name = "nixshell";
      runtimeInputs = with super; [
        nix
        bash
      ];
      file = name;
    };
    pond = customDerivation "pond";
    prettier-plugin-astro = customDerivation "prettier-plugin-astro";
    prettier-plugin-jinja-template = customDerivation "prettier-plugin-jinja-template";
    search = customScript {
      name = "search";
      runtimeInputs = with super; [
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
        ./derivations/vesktop/discord.tar.gz
      ];
      sourceRoot = "source"; # move into git repo
      patches = oldAttrs.patches ++ [
        ./derivations/vesktop/shiggy.patch
        ./derivations/vesktop/icon.patch
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
    gh-actions-language-server = customDerivation "gh-actions-language-server";
    vimPlugins =
      super.vimPlugins
      // {
        nvim-navic = super.vimPlugins.nvim-navic.overrideAttrs {
          dependencies = [ ];
        };
        otter-nvim = super.vimPlugins.otter-nvim.overrideAttrs {
          dependencies = [ ];

        };
      }
      // builtins.mapAttrs (_name: value: (githubVimPlugin value)) {
        cmp-scss = {
          author = "mmolhoek";
          repo = "cmp-scss";
          rev = "fef96e1";
          hash = "sha256-SzkK05yj5Ys0JSMb5Xow79YtwikUtTuRDurs8UfW1pc=";
        };
        markdown-plus-nvim = {
          author = "YousefHadder";
          repo = "markdown-plus.nvim";
          rev = "v2.0.0";
          hash = "sha256-ovVbPXRmiY5hWgkCNCgW/zYdg/l3Fq4A/rXPHDYdu7U=";
        };
        mdx-nvim = {
          author = "davidmh";
          repo = "mdx.nvim";
          rev = "3022299";
          hash = "sha256-QaPYSTH59j8tUa5rTY8I9VdQWLkhy8SWhNigEXHFn1c=";
        };
        modes-nvim = {
          author = "mvllow";
          repo = "modes.nvim";
          rev = "0932ba4";
          hash = "sha256-SXx1S/yBDTddb/oncHmfvpdO2oUNbgUjBItnudDAIE8=";
        };
        nvim-comment-frame = {
          author = "s1n7ax";
          repo = "nvim-comment-frame";
          rev = "5719db5";
          hash = "sha256-xrbQe0zp79K2GYtN3Pi96xywQEfIPjfPLZGscUXq1z0=";
        };
      };
    whichl = customScript {
      name = "whichl";
      file = "whichl";
      runtimeInputs = with super; [
        which
        eza
      ];
    };
  }
)
