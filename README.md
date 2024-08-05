# NixOS-Config Structure

## Directory Tree
├── scripts
│	├── autostart.sh
│	├── brightness-control.sh
│	├── choose-option-or-backup.nix
│	├── clean.sh
│	├── get-package-dir.sh
│	├── git-mv.sh
│	├── home-manager-rollback.sh
│	├── locate-desktop.nix
│	├── nix-search-wrapper.sh
│	├── notes.md
│	├── printscreen.sh
│	├── rebuild.sh
│	├── rebuild.sh
│	├── set-custom-gnome-keybinds.nix
│	└── theme-config.nix
│
├── homemanager
│	├── derivations
│	│	├── dconf2nix.nix
│	│	├── ds9.nix
│	│	├── gaia.nix
│	│	└── starfetch.nix
│	│
│	├── desktop-environment
│	│	├── autostart-programs.nix
│	│	├── default.nix
│	│	├── fonts.nix
│	│	├── icons.txt
│	│	├── shell.nix
│	│	├── taskbar-programs.nix
│	│	└── xdg.nix
│	│
│	├── package-configuration
│	│	├── bash.nix
│	│	├── copyq.nix
│	│	├── copyq.conf
│	│	├── dash-to-panel.nix
│	│	├── dash-to-panel.dconf
│	│	├── dolphin.nix
│	│	├── dolphinrc.toml
│	│	├── dolphinui.xml
│	│	├── eza.nix
│	│	├── forge.nix
│	│	├── forge.dconf
│	│	├── fzf.nix
│	│	├── git.nix
│	│	├── gpg.nix
│	│	├── python-qstar.yml
│	│	├── sublime-text.nix
│	│	├── sublime-text-keymap.json
│	│	├── sublime-text-theme.json
│	│	├── sublime-text-preferences.json
│	│	├── tilix.nix
│	│	├── vscodium.nix
│	│	├── vscodium-keybindings.json
│	│	└── vscodium-settings.json
│	│
│	├── home.nix
│	├── flake.nix
│	├── flake.lock
│	└── packages.nix
│
├── nix-scripts
│	├── autostart.nix
│	├── choose-option-or-backup.nix
│	├── set-custom-gnome-keybinds.nix
│	└── locate-desktop.nix
│
├── system
│	├── configuration.nix
│	├── flake.lock
│	├── flake.nix
│	└── hardware-configuration.nix
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