{config, ...}: {
  programs.bash = {
    enable = true; # apply home.shellAliases to bash
    historyFile = "${config.xdg.stateHome}/bash/history"; # clean up homedir
    bashrcExtra = "export HISTFILE=\"\${XDG_STATE_HOME}\"/bash/history";
  };
}
