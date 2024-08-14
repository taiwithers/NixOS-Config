{
  description = "Activate FHS environment for Python with micromamba";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = {nixpkgs, ...}: let
    system = builtins.currentSystem;
    pkgs = import nixpkgs {inherit system;};
    fhs = {
      name = "mamba-fhs";
      targetPkgs = _: [pkgs.micromamba];
      profile = ''
        export MAMBA_ROOT_PREFIX=$XDG_STATE_HOME/micromamba
        eval "$(micromamba shell hook --shell posix --root-prefix $MAMBA_ROOT_PREFIX)"
      '';
      runScript = "bash --init-file ~/.config/NixOS-Config/home-manager/pkgs/python/shells/shellrc.sh";
    };
    qstar = {
      name = fhs.name;
      targetPkgs = fhs.targetPkgs;
      profile = fhs.profile + "\n micromamba activate qstar";
    };
  in {
    devShells.${system} = {
      default = (pkgs.buildFHSEnv fhs).env;
      qstar = (pkgs.buildFHSEnv qstar).env;
    };
  };
}
