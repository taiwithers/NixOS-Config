- write /etc/nixos/flake.nix
- edit /etc/nixos/configuration.nix
- sudo nixos-rebuild switch
- edit until this succeeds
- nix run home-manager/release-23.11 -- init
- edit ~/.config/home-manager/flake.nix and ~/.config/home-manager/home.nix
- nix run home-manager/release-23.11 -- init --switch
- edit until this succeeds
- should now be able to run home-manager switch


`home-manager switch --flake ~/.config/NixOS-Config/homemanager --show-trace`
`sudo nixos-rebuild switch --flake ~/.config/NixOS-Config/system --show-trace`