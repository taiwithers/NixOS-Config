{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  app-themes,
  fonts,
  ...
}:
{
  imports =
    map (fname: import ./pkgs/${fname}.nix { inherit config pkgs app-themes; }) [
      "agenix/agenix"
      "bash"
      "bat"
      # "blesh"
      "bottom"
      "cod"
      "common-git"
      "duf"
      "dust"
      "eza"
      "fzf"
      "lazygit"
      "neovim/neovim"
      "starship"
      "superfile"
      "zellij"
      "zoxide"
    ]
    ++ [ flake-inputs.agenix.homeManagerModules.default ];

  common.nixConfigDirectory = "/mnt/c/Users/tai/Documents/Git/NixOS-Config";
  common.useXDG = true;
  common.nixos = true;

  home.packages =
    with pkgs;
    [
      age
      cbonsai
      fastfetch
      fd
      nix-output-monitor
      pond
      ripgrep
      ripgrep-all
      shellcheck
      starfetch
      trashy
      xdg-ninja
      zellij
    ]
    ++ (map
      (
        {
          name,
          runtimeInputs ? [ ],
          file,
        }:
        pkgs.writeShellApplication {
          name = name;
          runtimeInputs = runtimeInputs;
          text = builtins.readFile file;
        }
      )
      [
        rec {
          name = "get-package-dir";
          runtimeInputs = with pkgs; [
            coreutils
            which
          ];
          file = ../scripts + "/${name}.sh";
        }
        rec {
          name = "clean";
          runtimeInputs = with pkgs; [
            coreutils
            gnugrep
            gnused
            home-manager
            nix
          ];
          file = ../scripts + "/${name}.sh";
        }
        rec {
          name = "search";
          runtimeInputs = with pkgs; [
            nix-search-cli
            sd
            jq
            nix
          ];
          file = ../scripts/nix-search-wrapper.sh;
        }
        {
          name = "fix-line-endings";
          runtimeInputs = with pkgs; [
            fd
            dos2unix
          ];
          file = ../scripts/fix-line-endings.sh;
        }
      ]
    );

  home.stateVersion = "24.05";
}
