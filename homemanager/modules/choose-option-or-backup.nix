{
  functionOptionIsValid,
  allOptions,
}: let
  availableOptions = builtins.filter functionOptionIsValid allOptions;
in
  builtins.head availableOptions
