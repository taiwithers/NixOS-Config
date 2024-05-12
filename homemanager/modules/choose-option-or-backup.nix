{
  functionOptionIsValid,
  allOptions,
}: {
  firstAvailableOption = let
    availableOptions = builtins.filter functionOptionIsValid allOptions;
  in
    builtins.head availableOptions;
}
