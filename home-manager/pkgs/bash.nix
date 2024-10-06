{ ... }:
{
  programs.bash = {
    enable = true; # apply home.shellAliases to bash
    historyFile = "$XDG_STATE_HOME/bash_history";
    enableVteIntegration = true; # no idea what this is
    historyControl = [ "ignoredups" ];
    shellAliases = {
      brc = "source ~/.bashrc";
      bbrc = "bat ~/.bashrc";
    };
  };
}
