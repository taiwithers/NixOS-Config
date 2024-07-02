{ config, ... }:
{
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg"; # clean up homedir
  };
}
