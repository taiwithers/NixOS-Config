# NixOS-Config Structure

## Directory Tree
├── derivations
│	├── cbonsai.nix
│	├── color-oracle.nix
│	├── ds9.nix
│	├── gaia.nix
│	├── pond.nix
│	└── starfetch.nix
│
├── home-manager
│	├── pkgs (directory)
│	├── common.nix
│	├── nixos-main.nix (home.nix)
│	├── nixos-wsl.nix
│	├── ubuntu-wsl.nix (wsl-home.nix)
│	├── ubuntu-main.nix (group-home.nix)
│	├── flake-home-manager.nix
│	└── flakelock-home-manager.lock
│
├── scripts (directory)
│
├── nixos
│	├── main
│	│	├── configuration.nix
│	│	└── hardware.nix
│	│
│	├── wsl
│	│	├── configuration.nix
│	│	└── hardware.nix
│	│
│	├── flake-nixos.nix
│	└── flakelock-nixos.lock
│
├── .gitignore
└── README.md

## Items
- Home Manager configuration

- Desktop Environment Configuration
	- autostart programs
	- taskbar programs
	- custom keyboard shortcuts
	- xdg home directories
	- mime types
	- gnome dconf settings
	- gnome keybindings
	- fonts download
	- gnome extensions installation and configuration
	- shell aliases

- Program Configuration
	- git configuration
	- fzf configuration
	- copyq service
	- bash configuration
	- gpg configuration
	- tilix configuration
	- tilix themeing
	- fzf theming
	- sublime text configuration
	- vs codium configuration

- installed packages
- theme selection

## Usage

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