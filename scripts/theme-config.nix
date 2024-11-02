{
  pkgs,
  arc,
  ...
}:
rec {
  colourschemes = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "schemes";
    rev = "43294f1";
    hash = "sha256-spz4qmUaejGLB6k/RKc7k+unbNogedwdQv5yBoL3ThA=";
  };

  importYamlScheme =
    let
      findStrings = [
        "palette:"
        "  "
      ];
      replaceStrings = builtins.genList (str: "") (builtins.length findStrings);
    in
    theme:
    arc.lib.fromYAML (
      builtins.replaceStrings findStrings replaceStrings (
        builtins.readFile "${colourschemes}/${theme}.yaml"
      )
    );

  toFileName =
    theme:
    pkgs.lib.toLower (
      builtins.replaceStrings
        [
          "/"
          " "
        ]
        [
          "-"
          "-"
        ]
        theme
    );

  makeNamedPalette =
    themeDict: conversionDict:
    (builtins.mapAttrs (name: value: (builtins.getAttr value themeDict)) conversionDict);

  makePaletteSet = themeDict: (builtins.mapAttrs (name: value: importYamlScheme value) themeDict);

  makePathSet = themeDict: (builtins.mapAttrs (name: value: toFileName value) themeDict);
}
