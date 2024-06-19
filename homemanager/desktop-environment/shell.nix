{
  config,
  pkgs,
  ...
}: {
  home.shellAliases = let
    bashScripts = "${config.xdg.configHome}/NixOS-Config/scripts";
  in {
    # use new programs
    "grep" = "rg";
    "du" = "echo 'Consider using dust instead'";
    "df" = "echo 'Consider using duf instead'";
    "ls" = "eza";
    "tree" = "eza --tree";
    "man" = "batman --no-hyphenation --no-justification";

    # simplify commands
    "untar" = "tar -xvf";
    "confdir" = "cd ~/.config/NixOS-Config";
    "lg" = "lazygit";
    "dust" = "dust --reverse";
    "wget" = "wget --hsts-file=''$XDG_DATA_HOME/wget_hsts";
    "group" = "ssh $GROUP_USERNAME@$GROUP_HOSTNAME -XY";
    "groupscp" = "scp -r $GROUP_USERNAME@$GROUP_HOSTNAME";

    # personal bash scripts -> move these to pkgs.writeShellScriptBin
    "rebuild" = "bash ${bashScripts}/rebuild.sh";
    "get-package-dir" = "bash ${bashScripts}/get-package-dir.sh";
    "search" = "bash ${bashScripts}/nix-search-wrapper.sh";
    "printscreen" = "bash ${bashScripts}/printscreen.sh";
    "gmv" = "bash ${bashScripts}/git-mv.sh";

    # other hacks and fixes
    "clear" = "/run/current-system/sw/bin/clear"; # don't use ~/.conda/bin/clear which doesn't work outside conda-shell
  };

  # programs.bash.bashrcExtra = "export DOTNET_ROOT=${pkgs.dotnet-sdk_7}";
}
