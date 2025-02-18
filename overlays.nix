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
    blesh = super.blesh.overrideAttrs (_oldAttrs: rec {
      version = "3d8f626";
      source = super.fetchFromGitHub {
        owner = "akinomyoga";
        repo = "ble.sh";
        rev = version;
        hash = "sha256-0QnFFHkVIyXXoHQQfUKeRyLg3/2rb49MTMHydzAzq4A=";
        # hash = "sha256-dVvm089c9Qt5dzrk8n/Ow/y3WVFjAdT5G3hXAl5MghM=";
      };
    });
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
    inherit (unstable) nix-search-tv;
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
    inherit (unstable) karp;
    kdePackages = super.kdePackages // {
      inherit (super) kara;
      klassy = super.nur.repos.shadowrz.klassy-qt6.overrideAttrs (oldAttrs: rec {
        version = "58c6ad5";
        src = super.fetchFromGitHub {
          owner = "paulmcauley";
          repo = oldAttrs.pname;
          rev = version;
          hash = "sha256-B7nQVok/3uCskGykqEoaZcpzpIk15tT7qDPG3qCbn4Q=";
        };
      }); # customDerivation "klassy";
      inherit (unstable.kdePackages) krohnkite;
    };
    nixfmt = super.nixfmt-rfc-style;
    nixshell = customScript rec {
      name = "nixshell";
      runtimeInputs = with super; [
        nix
        bash
      ];
      file = name;
    };
    inherit (unstable) onedrive;
    pond = customDerivation "pond";
    rofi-calc = super.rofi-calc.override {
      rofi-unwrapped = self.rofi-wayland-unwrapped;
    };
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
        inherit (unstable.vimPlugins) snacks-nvim;
      }
      // builtins.mapAttrs (_name: value: (githubVimPlugin value)) {
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
    whichl = customScript {
      name = "whichl";
      file = "whichl";
      runtimeInputs = with super; [ which eza ];
    };
    zoom-us =
      (super.zoom-us.override {
        pipewire = self.pipewire-zoom;
      }).overrideAttrs
        (_oldAttrs: rec {
          version = "6.0.2.4680";
          src = super.fetchurl {
            url = "https://zoom.us/client/${version}/zoom_x86_64.pkg.tar.xz";
            hash = "sha256-027oAblhH8EJWRXKIEs9upNvjsSFkA0wxK1t8m8nwj8=";
          };
        });
  }
)
