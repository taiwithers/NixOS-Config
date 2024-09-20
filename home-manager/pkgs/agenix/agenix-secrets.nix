let
  wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJpPT5RKa6SMlFrDwb2MX67xHSTzmqwKpfjwDaQIsI4e";
  main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOznzzcU/N3dZhtkr0N90vj5LgfyOaZkOKhChwpzDo/W";
in {
  "ssh-config-group.age".publicKeys = [wsl main];
}
