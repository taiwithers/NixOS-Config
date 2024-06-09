{config, ...}: {
  home.shellAliases = let
    bashScripts = "${config.xdg.configHome}/NixOS-Config/bash-scripts";
  in {
    # use new programs
    "grep" = "rg";
    "du" = "duf";
    "ls" = "eza";
    "tree" = "eza --tree";
    "man" = "batman --no-hyphenation --no-justification";

    # simplify commands
    "untar" = "tar -xvf";
    "confdir" = "cd ~/.config/NixOS-Config";
    "lg" = "lazygit";

    # personal bash scripts -> move these to pkgs.writeShellScriptBin
    "rebuild" = "bash ${bashScripts}/rebuild.sh";
    "get-package-dir" = "bash ${bashScripts}/get-package-dir.sh";
    "search" = "bash ${bashScripts}/nix-search-wrapper.sh";
  };
}
