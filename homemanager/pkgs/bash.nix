{  ... }:
{
  programs.bash = {
    enable = true; # apply home.shellAliases to bash
    historyFile = "$XDG_STATE_HOME/bash_history";
    bashrcExtra =
      # bash 
      ''
        # __NIX_BIN="$HOME/.nix-profile/bin"
        # if ! [[ "$PATH" =~ "$__NIX_BIN" ]]; then
        #     export PATH="$__NIX_BIN:$PATH"
        # fi
        # unset __NIX_BIN

        # source-secrets
        # unset __HM_SESS_VARS_SOURCED
        # source ~/.profile # try to get home manager's session variables working

        mkdir -p \"$(dirname $HISTFILE)\"
      '';
    shellAliases = {
      brc = "source ~/.bashrc";
      bbrc = "bat ~/.bashrc";
    };
  };
}
