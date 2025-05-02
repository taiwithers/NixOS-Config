```sh
cd ~
nix-shell --packages git --command "git clone https://github.com/taiwithers/NixOS-Config.git Nix"

sudo nixos-rebuild switch --show-trace --flake ./NixOS-Config/nixos#main
nix run home-manager/release-24.11 -- init --switch
home-manager switch --show-trace --flake ./NixOS-Config/home-manager#nixos-main -b backup

# export MAMBA_ROOT_PREFIX=~/.local/state/micromamba
# eval "$(micromamba shell hook --shell posix --root-prefix $MAMBA_ROOT_PREFIX)"
# micromamba create --file {ta.yml} --yes --root-prefix $MAMBA_ROOT_PREFIX
```
