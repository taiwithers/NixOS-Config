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
git clone config
# update wsl.defaultUser in configuration.nix
exit # exit shell
sudo nixos-rebuild boot # not switch!
exit # exit wsl

# powershell
wsl --terminate NixOS
wsl --distribution NixOS --user root exit # replace root with value of wsl.wslConf.user.default in configuration
wsl --terminate NixOS

# re-open wsl shell, which should have new username
```