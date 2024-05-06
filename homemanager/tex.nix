{
  config,
  pkgs,
  ...
}: {
  mytex = pkgs.texliveMinimal.withPackages (ps:
    with ps; [
      standalone
    ]);

  home.packages = [mytex];
}
