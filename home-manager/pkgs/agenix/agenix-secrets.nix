let
  wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKolW4+sDPYJHL0XSZ+i/XRpj/7tZRMsktKGOyAQcGAy";
  main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOznzzcU/N3dZhtkr0N90vj5LgfyOaZkOKhChwpzDo/W";
in {
  "ssh-config-group.age".publicKeys = [wsl main];
}
