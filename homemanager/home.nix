{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  app-themes,
  ...
}:
{
  imports = [
    flake-inputs.nixvim.homeManagerModules.nixvim
    (import ./desktop-environment { inherit config pkgs; })
    (import ./packages { inherit config pkgs app-themes; })
  ];

  home.stateVersion = "23.11";
}
