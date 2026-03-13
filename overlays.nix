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
        inherit name;
        runtimeInputs = runtimeInputs ++ [ super.coreutils ];
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
    brightness-control = customScript rec {
      name = "brightness-control";
      runtimeInputs = [ super.brightnessctl ];
      file = name;
    };
    cbonsai = customDerivation "cbonsai";
    clean = customScript rec {
      name = "clean";
      runtimeInputs = with super; [
        gnugrep
        gnused
        home-manager
        nix
        coreutils
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
    color-oracle = customDerivation "color-oracle";
    # deskflow = unstable.deskflow.override {
    #     qt6 = self.qt6;
    #   };
    diff-nix-generations = customScript rec {
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
    # inherit (unstable) nix-search-tv;
    nixos-generations = customScript rec {
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
    # inherit (unstable) karp;
    kdePackages = super.kdePackages // {
      inherit (super) kara darkly;
      klassy = customDerivation "klassy";
      # klassy = super.nur.repos.shadowrz.klassy-qt6.overrideAttrs (oldAttrs: rec {
      #   version = "58c6ad5";
      #   src = super.fetchFromGitHub {
      #     owner = "paulmcauley";
      #     repo = oldAttrs.pname;
      #     rev = version;
      #     hash = "sha256-B7nQVok/3uCskGykqEoaZcpzpIk15tT7qDPG3qCbn4Q=";
      #   };
      # });
      inherit (unstable.kdePackages) krohnkite;
    };
    nbpreview = customDerivation "nbpreview";
    # nixfmt = super.nixfmt-rfc-style;
    nixshell = customScript rec {
      name = "nixshell";
      runtimeInputs = with super; [
        nix
        bash
      ];
      file = name;
    };
    # inherit (unstable) onedrive;
    pond = customDerivation "pond";
    prettier-plugin-astro = customDerivation "prettier-plugin-astro";
    search = customScript rec {
      name = "search";
      runtimeInputs = with super; [
        nix-search-cli
        sd
        jq
        nix
      ];
      file = "nix-search-wrapper";
    };
    select-browser = customScript rec {
      name = "select-browser";
      runtimeInputs = with super; [
        rofi
      ];
      file = name;
    };
    starfetch = customDerivation "starfetch";
    inherit (unstable) sublime4;
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
    vimPlugins =
      super.vimPlugins
      // {
        inherit (unstable.vimPlugins) nvim-tree-lua nui-nvim nvim-notify;
      }
      // builtins.mapAttrs (_name: value: (githubVimPlugin value)) {
        darkvoid-nvim = {
          author = "darkvoid-theme";
          repo = "darkvoid.nvim";
          rev = "45be993";
          hash = "sha256-JiNuv1TAIHVL9tGNDYC0RdRPnI9l4zn+ZCU9B4wQ5Io=";
        };
        f-string-toggle-nvim = {
          author = "roobert";
          repo = "f-string-toggle.nvim";
          rev = "74545e6";
          hash = "";
        };
        modes-nvim = {
          author = "mvllow";
          repo = "modes.nvim";
          rev = "0932ba4";
          hash = "sha256-SXx1S/yBDTddb/oncHmfvpdO2oUNbgUjBItnudDAIE8=";
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
