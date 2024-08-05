{ config, pkgs, ... }:
let
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
in
{
  sops = {
    defaultSopsFile = builtins.toString ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/tai/.config/sops/age/keys.txt";
    validateSopsFiles = false;

    secrets = {
      group_hostname.owner = local-username;
      group_username.owner = local-username;
      github_api_pat = { };
    };

    templates."${source-script}" = {
      owner = local-username;
      content = ''
        export GROUP_USERNAME=${config.sops.placeholder.group_username}
        export GROUP_HOSTNAME=${config.sops.placeholder.group_hostname}
      '';
    };
  };

  nix.extraOptions = "access-tokens = github.com=${builtins.readFile config.sops.secrets.github_api_pat.path}";

  environment.shellInit = "source ${source-path}";
  environment.shellAliases."source-secrets" = "source ${source-path}";

  environment.systemPackages = [ pkgs.sops ];
  # home.activation.custom-sops-nix = let
  #   systemctl = config.systemd.user.systemctlPath;
  # in "${systemctl} --user reload-or-restart sops-nix";

  # home.activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
  #   /run/current-system/sw/bin/systemctl start --user sops-nix
  # '';
}

# add sops to flake inputs
# add sops HM to tai-wsl flake modules
# add sops and age to home packages
# mkdir --parents ~/.config/sops/age
# sops ~/.config/NixOS-Config/secrets/secrets.yaml
# ^ fails bc no public key is available at ~/.config/sops/age/keys.txt to decrypt
# age-keygen --output ~/.config/sops/age/keys.txt
# get public key with: age-keygen -y ~/.config/sops/age/keys.txt
# add public key to .sops.yaml
# sops --config ~/.config/NixOS-Config/system/sops/.sops.yaml [sops file to edit, e.g. ~/.config/NixOS-Config/homemanager/sops-wsl.yaml]
# now all public keys listed in --config are able to access/decrypt [sops file]
