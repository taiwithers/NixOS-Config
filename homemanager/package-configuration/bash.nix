{config, ...}: {
  programs.bash = {
    enable = true; # apply home.shellAliases to bash
    historyFile = "${config.xdg.stateHome}/bash/history"; # clean up homedir
    # bashrcExtra = "";
  };

  # programs.blesh.enable = true; # enable ble.sh
}
