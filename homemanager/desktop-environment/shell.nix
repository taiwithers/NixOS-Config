{config, ...}: {
  home.shellAliases = {
    "grep" = "rg";
    "untar" = "tar -xvf";
    "ls" = "eza";
    "tree" = "eza --tree";
    "rebuild" = "bash ${config.xdg.configHome}/NixOS-Config/bash-scripts/rebuild.sh";
    "mamba" = "micromamba";
    "man" = "batman";
    "get-package-dir" = "bash ${config.xdg.configHome}/NixOS-Config/bash-scripts/get-package-dir.sh";

    "search" = "echo 'searching nixpkgs:23.11'; nix-search --channel=23.11";
  };
}
