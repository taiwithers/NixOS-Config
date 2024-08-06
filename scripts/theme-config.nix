{
  pkgs,
  arc,
  ...
}: rec {
  colourschemes = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "schemes";
    rev = "ef9a4c3";
    hash = "sha256-9i9IjZcjvinb/214x5YShUDBZBC2189HYs26uGy/Hck=";
  };

  importYaml = let
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

  toFileName = theme:
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
