{
  config,
  pkgs,
  flake-inputs,
  colours,
  ...
}:
{
  # nix run home-manager/release-26.05 -- switch --impure --flake ./path-to-flake#output-name
  imports =
    [ ]
    ++ (map
      (
        fname:
        import (./. + "/pkgs/${fname}.nix") {
          inherit
            config
            pkgs
            colours
            ;
        }
      )
      [
        "bash"
        "bat"
        # "blesh" # uses colours
        # "bottom"
        # "cod"
        "duf"
        "dust"
        "eza"
        "fzf"
        # "lazygit"
        "neovim/neovim"
        "ripgrep"
        # "starship"
        "tldr"
        "yazi"
        "zoxide"
      ]
    );

  home.packages = [ ];

  programs.bash.bashrcExtra = ''
    # add completions
    complete -F _command get-package-path
    complete -F _command whichl
  '';

  common.nixConfigDirectory = "${config.home.homeDirectory}/Nix";
  common.useXDG = true;
  common.nixos = false;

  home.stateVersion = "26.05";
}
