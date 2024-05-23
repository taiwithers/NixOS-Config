{config, ...}: {
  home.shellAliases = let
    bashScripts = "${config.xdg.configHome}/NixOS-Config/bash-scripts";
  in {
    "grep" = "rg";
    "untar" = "tar -xvf";
    "ls" = "eza";
    "tree" = "eza --tree";
    "rebuild" = "bash ${bashScripts}/rebuild.sh";
    "mamba" = "micromamba";
    "man" = "batman";
    "get-package-dir" = "bash ${bashScripts}/get-package-dir.sh";

    "search" = "bash ${bashScripts}/nix-search-wrapper.sh";
    # "search" = "echo 'searching nixpkgs:23.11'; nix-search --channel=23.11";
    # "search-unstable" = "echo 'searching nixpkgs:unstable'; nix-search --channel=unstable";
  };
}
