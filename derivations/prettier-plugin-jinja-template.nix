# https://github.com/NixOS/nixpkgs/blob/nixos-25.11/pkgs/by-name/pr/prettier-plugin-go-template/package.nix#L30
{
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage {
  pname = "prettier-plugin-jinja-template";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "davidodenwald";
    repo = "prettier-plugin-jinja-template";
    rev = "7709de3";
    hash = "sha256-OBpY8XYG6Hn2sQpWoJkNJGsnZ1Lh7LAviofgCRFMXwk=";
  };

  npmDepsHash = "sha256-YsrDWoaA5EdQi3uzuWBx3Jv1US0qWwkh+636dfvlAkI=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r lib/ $out
    cp -r node_modules/ $out

    runHook postInstall
  '';
}
