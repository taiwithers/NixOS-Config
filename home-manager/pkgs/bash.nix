{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true; # apply home.shellAliases to bash
    historyFile = "$XDG_STATE_HOME/bash_history";
    # enableVteIntegration = true; # no idea what this is
    historyControl = [ "ignoredups" ];
    shellAliases = {
      brc = "source ~/.bashrc";
      bbrc = "bat ~/.bashrc";
    };

    initExtra = pkgs.lib.mkAfter ''
      source ${../../scripts/clean-path.sh}
      clean_path
    '';

    bashrcExtra = ''
      source ${config.common.nixConfigDirectory}/scripts/backup.sh
    '';
  };
}
