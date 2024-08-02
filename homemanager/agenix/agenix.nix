let
  wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKolW4+sDPYJHL0XSZ+i/XRpj/7tZRMsktKGOyAQcGAy";
in
{
  "group_hostname.age".publicKeys = [ wsl ];
}
