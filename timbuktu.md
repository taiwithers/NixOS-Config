Download into ~/opt, unpack and symlink binary into ~/.local/bin
https://github.com/[replace]/releases/latest
- eza - eza-community/eza
	- add bash aliases
- fzf - junegunn/fzf
	- shell hook
	- add session variables
- starship - starship/starship/releases
	- shell hook
	- scp ~/.config/starship.toml
- zoxide - ajeetdsouza/zoxide
	- shell hook
	- session variables
- ripgrep - BurntSushi/ripgrep
- fd - sharkdp/fd (used for fzf and zoxide)
- delta - dandavison/delta
- nvim - neovim/neovim
	- scp ~/.config/nvim/lua/options.lua as ~/.config/nvim/init.lua
- miniforge3 (conda/mamba manager) conda-forge/miniforge
	- yes shell hook
	- no symlink
	- `conda config --set auto_activate_base false`
	
Special install instructions
- trash-cli - andreafrancia/trash-cli - pip install trash-cli
- blesh - akinomyoga/ble.sh
	- scp -r ~/.config/blesh
- git
	- scp -r ~/.config/git
	- chmod a+w ~/.config/git/*
	- nvim ~/.config/git/config

mkdir ~/.ssh
scp ~/.ssh/id_* ~/.ssh


mamba self-update
ble-update
eza --version (no update script)
fzf --version (no update script)
starship --version (no update script)
zoxide --version (no update script)
rg --version (no update script)
delta --version (no update script)
nvim --version (no update script)
trash --version (no update script)


- create and activate project-specific mamba environment
- inside mamba environment `pip install poetry=1.8`
- clone the various repos into ~/gjw/morse
- `poetry install` from the morse-pipeline directory
- copy a config file from morse-pipeline/config to ~/gjw/data
- edit the config file to do things relative to ~/gjw/data
- `poetry run morse_pipeline config=<configpath>` from the morse-pipeline directory

