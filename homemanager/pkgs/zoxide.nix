{config, ... }:
{
  programs.zoxide = {
    enable = true;
    options = [ ];
  };
  home.shellAliases."cd" = "echo 'Consider using zoxide [z]'";
  home.sessionVariables = {
    _ZO_ECHO = 1; # print before cd
    _ZO_EXCLUDE_DIRS = "$HOME";
    _ZO_FZF_OPTS = builtins.concatStringsSep " " config.programs.fzf.changeDirWidgetOptions;
    _ZO_RESOLVE_SYMLINKS = 1;
  };
}
