{ ... }:
{
  home.shellAliases = {
    # use new programs
    "grep" = "echo 'Consider using ripgrep [rg] or batgrep instead'";
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
    "group" = "ssh -XY $GROUP_USERNAME@$GROUP_HOSTNAME";
    "groupscp" = "scp -r $GROUP_USERNAME@$GROUP_HOSTNAME";
    "which" = "which -a";

    # other hacks and fixes
    # "clear" = "/run/current-system/sw/bin/clear"; # don't use ~/.conda/bin/clear which doesn't work outside conda-shell
  };

  # programs.bash.bashrcExtra = "export DOTNET_ROOT=${pkgs.dotnet-sdk_7}";
}
