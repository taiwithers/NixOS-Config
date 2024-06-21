{config, ...}: {
  programs.bash = {
    enable = true; # apply home.shellAliases to bash
    bashrcExtra = ''

      # clean up ~
      export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
      export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
      export HISTFILE="${config.xdg.stateHome}/bash/history"
      mkdir -p "$(dirname $HISTFILE)"

      alias "brc"="source ~/.bashrc"
    '';
    # bashrcExtra = "export HISTFILE=\"\${XDG_STATE_HOME}\"/bash/history";
  };
}
