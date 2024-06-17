{config, ...}: let
  # setup sops and age
  # mkdir --parents ~/.config/sops/age
  # age-keygen --output ~/.config/sops/age/keys.txt
  # to get public key:
  # age-keygen -y ~/.config/sops/age/keys.txt
  # setup secrets
  # sops ~/.config/NixOS-Config/secrets/secrets.yaml
  source-script = "variables.sh";
  source-path = "/run/secrets-rendered/${source-script}";
  local-username = config.users.users.tai.name;
in {
  sops = {
    defaultSopsFile = builtins.toString ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/tai/.config/sops/age/keys.txt";
    validateSopsFiles = false;

    secrets = {
      group_hostname.owner = local-username;
      group_username.owner = local-username;
    };

    templates."${source-script}" = {
      owner = local-username;
      content = ''
        export GROUP_USERNAME=${config.sops.placeholder.group_username}
        export GROUP_HOSTNAME=${config.sops.placeholder.group_hostname}
      '';
    };
  };

  environment.shellInit = "source ${source-path}";
  environment.shellAliases."source-secrets" = "source ${source-path}";

  # home.activation.custom-sops-nix = let
  #   systemctl = config.systemd.user.systemctlPath;
  # in "${systemctl} --user reload-or-restart sops-nix";

  # home.activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
  #   /run/current-system/sw/bin/systemctl start --user sops-nix
  # '';
}
