{ functionOptionIsValid, allOptions }:
let
  availableOptions = builtins.filter functionOptionIsValid allOptions;
in
if (builtins.length availableOptions) == 0 then "" else builtins.head availableOptions
