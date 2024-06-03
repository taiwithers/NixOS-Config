{config, ...}: {
  programs.bash = {
    enable = true; # apply home.shellAliases to bash
    historyFile = "${config.xdg.stateHome}/bash/history"; # clean up homedir
    bashrcExtra = "export ICEAUTHORITY=\"\${XDG_CACHE_HOME}\"/ICEauthority\n # ${config.home.profileDirectory}";
    # bashrcExtra = "export HISTFILE=\"\${XDG_STATE_HOME}\"/bash/history";
  };
}
