{ ... }:
{
  projectRootFile = "flake.nix"; # how to find root

  # settings.global.excludes = [ "*.toml" ];
  programs.deadnix.enable = true;
  # programs.deno.enable = pkgs.hostPlatform.system != "riscv64-linux";
  # programs.mdsh.enable = true;
  programs.nixfmt.enable = true;
  # programs.shellcheck.enable = true; # fails on the compact menu plasmoid
  # programs.shfmt.enable = pkgs.hostPlatform.system != "riscv64-linux";
  # programs.yamlfmt.enable = true;
}
