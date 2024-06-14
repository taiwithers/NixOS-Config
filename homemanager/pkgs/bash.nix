{config, ...}: {
  programs.bash = {
    enable = true; # apply home.shellAliases to bash
    historyFile = "${config.xdg.stateHome}/bash/history"; # clean up homedir
    bashrcExtra = ''

      # clean up ~
      export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
      export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

      alias "brc"="source ~/.bashrc"
    '';
    # bashrcExtra = "export HISTFILE=\"\${XDG_STATE_HOME}\"/bash/history";
  };
}
