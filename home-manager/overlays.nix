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
    blesh = super.blesh.overrideAttrs (oldAttrs: rec {
        version = "3d8f626";
        source = super.fetchFromGitHub {
            owner = "akinomyoga";
            repo = "ble.sh";
            rev = version;
            hash = "sha256-dVvm089c9Qt5dzrk8n/Ow/y3WVFjAdT5G3hXAl5MghM=";
          };
      });
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
    diff-nix-generations = customScript rec {
      name = "diff-nix-generations";
      runtimeInputs = with pkgs; [
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
    generations = customScript rec {
      name = "generations";
      runtimeInputs = with pkgs; [
        nix
        jq
      ];
      file = "nixos-generations";
    };
    get-package-path = customScript {
      name = "get-package-path";
      runtimeInputs = [ pkgs.which ];
      file = "get-package-dir";
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
      }); # customDerivation "klassy";
      krohnkite = unstable.kdePackages.krohnkite;
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
    select-browser = customScript rec {
        name = "select-browser";
        runtimeInputs = with pkgs; [
          rofi
        ];
        file = name;
    };
    starfetch = customDerivation "starfetch";
    sublime4 = unstable.sublime4;
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
