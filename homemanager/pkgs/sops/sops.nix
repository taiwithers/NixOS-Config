{config, ...}: let
  # setup sops and age
  # mkdir --parents ~/.config/sops/age
  # age-keygen --output ~/.config/sops/age/keys.txt
  # to get public key:
  # age-keygen -y ~/.config/sops/age/keys.txt
  # setup secrets
  # sops ~/.config/NixOS-Config/secrets/secrets.yaml
in {
  sops = {
    defaultSopsFile = "${config.xdg.configHome}/NixOS-Config/secrets/secrets.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    validateSopsFiles = false;

    secrets = {
      group_hostname = {
        path = "$HOME/hostname";
      };
      group_username = {};
    };
  };

  # home.activation.custom-sops-nix = let
  #   systemctl = config.systemd.user.systemctlPath;
  # in "${systemctl} --user reload-or-restart sops-nix";

  home.activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
    /run/current-system/sw/bin/systemctl start --user sops-nix
  '';
}
