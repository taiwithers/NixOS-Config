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

  importYaml =
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

  makePaletteSet = themeDict: (builtins.mapAttrs (name: value: importYaml value) themeDict);

  makePathSet = themeDict: (builtins.mapAttrs (name: value: toFileName value) themeDict);
}
