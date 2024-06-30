{config, ...}: {
  programs.bash = {
    enable = true; # apply home.shellAliases to bash
    bashrcExtra =
      /*
      bash
      */
      ''
        source-secrets

        # unset __HM_SESS_VARS_SOURCED
        # source ~/.profile # try to get home manager's session variables working

        # clean up ~
        export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
        export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
        export HISTFILE="${config.xdg.stateHome}/bash/history"
        mkdir -p "$(dirname $HISTFILE)"

        source <(cod init $$ bash) # cod completion
      '';
    shellAliases = {
      brc = "source ~/.bashrc";
    };
  };
}
