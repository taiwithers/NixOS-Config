{
  config,
  pkgs,
  flake-inputs,
  pkgs-config,
  app-themes,
  ...
}@home-inputs:
let
 shellApplications = map (
    {name, runtimeInputs?[], file}: pkgs.writeShellApplication {
      name=name; 
      runtimeInputs=runtimeInputs;
      text = builtins.readFile file;
      }) 
    [
      rec {
        name = "get-package-dir";
        runtimeInputs = with pkgs; [ coreutils which ];
        file = ../scripts +"/${name}.sh";
      }
      rec {
        name = "clean";
        runtimeInputs = with pkgs; [coreutils gnugrep gnused home-manager nix];
        file = ../scripts +"/${name}.sh";
      }
      rec {
        name = "search";
        runtimeInputs = with pkgs; [nix-search-cli sd jq nix];
        file = ../scripts/nix-search-wrapper.sh;
      }
    ];
in
{
  imports =
    map (fname: import ./pkgs/${fname}.nix { inherit config pkgs app-themes; }) [
      "python/python"
      "bash"
      "bat"
      "bottom"
      "cod"
      "common-git"
      "duf"
      "dust"
      "eza"
      "fzf"
      "gaia"
      "lazygit"
      "neovim/neovim"
      "starship"
      "superfile"
      "zoxide"
    ]
    ++ [ (import ./agenix.nix { inherit config pkgs; }) ];

  common.nixConfigDirectory = "${config.common.configHome}/NixOS-Config";
  common.useXDG = true;
  common.nixos = false;

  home.packages =
    with pkgs;
    [

      age
      agenix

      swayfx
      rofi
      qtile

      cbonsai
      dust # view specific info for directories
      fastfetch
      fd
      gcc
      gnumake
      latex
      lavat
      nixfmt
      nix-output-monitor
      pacvim
      pond
      qtikz
      ripgrep
      ripgrep-all
      shellcheck
      sgt-puzzles
      starfetch
      trashy
      tty-clock
      vitetris
      xdg-ninja
      zellij
    ]
    ++ shellApplications;

  programs.git = {
    extraConfig = {
      credential.credentialStore = "gpg";
    };
  };

  home.shellAliases = {
    "rebuild" = "home-manager switch --impure --show-trace --flake ${config.common.nixConfigDirectory}/homemanager |& nom";
    "bsession" = "bat ${config.common.hm-session-vars}";
  };
  home.stateVersion = "24.05";
}
