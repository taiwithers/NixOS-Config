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
      qtikz
      ripgrep
      ripgrep-all
      shellcheck
      starfetch
      trashy
      xdg-ninja
      zellij

      (pkgs.texlive.combine {
              inherit (pkgs.texlive)
              collection-basic
              collection-latex
              collection-latexrecommended
              aastex
              astro # planetary symbols
              babel-english
              derivative
              enumitem
              epsf
              helvetic
              hyphen-english
              hyphenat
              latexmk
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
              ulem # underlining
              upquote # Show "realistic" quotes in verbatim
              wrapfig
              ;})
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
    ]    ;

  programs.git = {
    extraConfig = {
      credential.credentialStore = "gpg";
    };
  };

  home.shellAliases = {
    "rebuild" = "home-manager switch --impure --show-trace --flake ~/.config/NixOS-Config/homemanager |& nom";
  };
  nix.package = pkgs.lix;

  targets.genericLinux.enable = true;
  home.stateVersion = "24.05";
}
