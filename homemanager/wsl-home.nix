{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  app-themes,
  ...
}:
let
  shell-scripts = builtins.attrValues (
    builtins.mapAttrs
      (name: fname: pkgs.writeShellScriptBin name (builtins.readFile ../scripts/${fname}.sh))
      {
        get-package-dir = "get-package-dir";
        gmv = "git-mv";
        clean = "clean";
      }
  );
in
{
  imports = map (fname: import ./pkgs/${fname}.nix { inherit config pkgs app-themes; }) [
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
  ];
  wayland.windowManager.sway.checkConfig = false;
  home.packages =
    with pkgs;
    [
      swayfx
      rofi
      tilix
      qtile

      cbonsai
      dust # view specific info for directories
      fastfetch
      fd
      gcc
      gnumake
      lavat
      nixfmt
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
    ++ shell-scripts
    ++ [
      (pkgs.writeShellApplication {
        name = "search";
        runtimeInputs = [
          nix
          nix-search-cli
          jq
          sd
        ];
        excludeShellChecks = [
          "SC2046"
          "SC2155"
          "SC2086"
          "SC2116"
          "SC2005"
          "SC2162"
        ];
        text = builtins.readFile ../scripts/nix-search-wrapper.sh;
      })
    ];

  programs.git = {
    signing.key = "~/.ssh/id_ed25519_github";
    extraConfig = {
      gpg.format = "ssh";
      credential.credentialStore = "gpg";
      core.autocrlf = "input";
      filter.lfs = {
        clean = "git-lfs clean -- %f";
      };
    };
  };


  home.shellAliases = {
    "rebuild" = "home-manager switch --impure --show-trace --flake ~/.config/NixOS-Config/homemanager |& nom";
  };

  home.preferXdgDirectories = true;
  targets.genericLinux.enable = true;

  nix.package = pkgs.lix;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    use-xdg-base-directories = true; # throws warning but is needed for correct location of hm-session-variables.sh
  };
  home.stateVersion = "24.05";
}
