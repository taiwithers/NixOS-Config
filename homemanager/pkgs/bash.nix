{  ... }:
{
  programs.bash = {
    enable = true; # apply home.shellAliases to bash
    historyFile = "$XDG_STATE_HOME/bash_history";
    bashrcExtra =
      # bash 
      ''
        mkdir -p \"$(dirname $HISTFILE)\"
      '';
    shellAliases = {
      brc = "source ~/.bashrc";
      bbrc = "bat ~/.bashrc";
    };
  };
}
