nix-colors:
with (import nix-colors.homeManagerModules.default {}); rec {
  # nix-colors-module = import ;
  colour-palette = nix-colors.colorSchemes."${builtins.head names}".palette;
  names = [
    "da-one-ocean" # dark vibrant
    "jabuti" # not available in nix-colors
    "horizon-terminal-dark" # vibrant, good!
    "framer"
    "ayu-dark"
    "hardcore"
    "porple" # washed out, grey-blue background
    "qualia" # black + vibrant pastels
    "rose-pine" # purple
    "zenbones" # orange/green/blue on black
  ];

  # app-themes = builtins.mapAttrs (appName: appTheme: nix-colors.colorSchemes."${appTheme}".palette) {
  #   tilix = "da-one-ocean"; # change this once nix-colors supports base 24
  #   superfile = "da-one-ocean";
  # };

  app-themes = {
    superfile = nix-colors.colorSchemes."da-one-ocean".palette;
  };

  # function: select available theme
  selectAvailableTheme = functionGetThemePath: let
    checkTheme = name: builtins.pathExists (functionGetThemePath name);
    firstAvailableTheme = import ../scripts/choose-option-or-backup.nix {
      functionOptionIsValid = checkTheme;
      allOptions = names;
    };
  in
    firstAvailableTheme;
}
