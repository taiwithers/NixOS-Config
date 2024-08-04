{...}: {
  programs.bash = {
    enable = true; # apply home.shellAliases to bash
    historyFile = "$XDG_STATE_HOME/bash_history";
    shellAliases = {
      brc = "source ~/.bashrc";
      bbrc = "bat ~/.bashrc";
    };
  };
}
