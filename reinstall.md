cd ~/.config
nix-shell --packages git --command "git clone https://github.com/taiwithers/NixOS-Config.git"

sudo nixos-rebuild switch --impure --show-trace --flake ./NixOS-Config/nixos#main
nix run home-manager/release-24.05 -- init --switch
home-manager switch --impure --show-trace --flake ./NixOS-Config/home-manager#nixos-main -b backup

export MAMBA_ROOT_PREFIX=~/.local/state/micromamba
eval "$(micromamba shell hook --shell posix --root-prefix $MAMBA_ROOT_PREFIX)"
micromamba create --file {ta.yml} --yes --root-prefix $MAMBA_ROOT_PREFIX