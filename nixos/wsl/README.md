# README.md

## Installation

[Instructions](https://nix-community.github.io/NixOS-WSL/install.html)

```
# powershell
wsl --import NixOS $env:USERPROFILE\NixOS\ nixos-wsl.tar.gz
wsl --set-default NixOS
wsl --distribution NixOS

# bash
sudo nix-channel --update
sudo nixos-rebuild switch
nix-shell --packages vim git
# go to NixOS-Config on windows or clone it
cd /mnt/c/Users/tai/Documents/Git/NixOS-Config
# update wsl.defaultUser in nixos/configuration.nix
sudo nixos-rebuild boot --flake ./nixos#wsl # not switch! need git in path for this
exit # exit shell
exit # exit wsl

# powershell
wsl --terminate NixOS
wsl --distribution NixOS --user tai-wsl exit # replace root with value of wsl.wslConf.user.default in configuration
wsl --terminate NixOS

wsl # re-open wsl shell, which should have new username

# install home-manager
nix run home-manager/release-24.05 -- init --switch 
home-manager switch --flake /mnt/c/Users/tai/Documents/Git/NixOS-Config/home-manager#nixos-wsl --impure --show-trace
```