{
  config,
  pkgs,
  ...
}: let
  agenix-directory = "${config.xdg.configHome}/NixOS-Config/homemanager/agenix";
  ssh-key = "${config.home.homeDirectory}/.ssh/id_ed25519_group";
  age-file = "ssh-config-group.age";
in {
  age.identityPaths = [ssh-key];
  age.secrets.group_hostname = {
    file = "${agenix-directory}/${age-file}";
    path = "${config.home.homeDirectory}/.ssh/config_group";
  };

  home.sessionVariables."RULES" = "${agenix-directory}/agenix-secrets.nix";
  home.shellAliases."editage" = "(cd ${agenix-directory}; agenix --edit ${age-file} --identity ${ssh-key} )";

  programs.ssh = {
    enable = true;
    includes = [config.age.secrets.group_hostname.path];
    matchBlocks."group" = {
      identityFile = ssh-key;
      forwardX11 = true;
      extraOptions = {
        RequestTTY = "yes";
        RemoteCommand = "cd $HOME/QSTAR && micromamba activate qstar && bash --login";
      };
    };
  };

  # home.packages = [pkgs.systemd];
  # home.activation."agenix" = "systemctl --user start agenix";
}
