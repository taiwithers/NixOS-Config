{config, ...}: {
  age.identityPaths = [ "/home/tai-wsl/.ssh/id_ed25519_group"];
  age.secrets = {
    group_hostname.file = ./agenix/group_hostname.age;
  };

  home.sessionVariables."RULES" = "${./agenix/agenix.nix}";
  home.shellAliases."editagenix" = "( cd ${./agenix} ; $EDIT group_hostname.age )";

}