# https://github.com/thamenato/nvf/blob/9c75c2a199af39fc95fb203636ce97d070ca3973/flake/pkgs/by-name/prettier-plugin-astro/package.nix#L8
{ fetchFromGitHub
, stdenv
, nodejs
, pnpm_9
}: stdenv.mkDerivation (finalAttrs: {
  pname = "prettier-plugin-astro";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "withastro";
    repo = "prettier-plugin-astro";
    rev = "1150195386a80221882d603dffa94990709395fb";
    hash = "sha256-XGPz4D2UKOonet0tX3up5mCxw3/69XYPScxb9l7nzpE=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-K7pIWLkIIbUKDIcysfEtcf/eVMX9ZgyFHdqcuycHCNE=";
  };


  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r dist/ $out
    cp -r node_modules/ $out

    runHook postInstall
  '';
})

