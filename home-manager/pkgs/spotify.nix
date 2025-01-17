{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.spotify ];
  # imports = [ spicetify-nix.homeManagerModules.default ];

  # programs.spicetify = let
  #   spicetify-pkgs = spicetify-nix.legacyPackages.${pkgs.system};
  #   in {
  #   enable = true;
  #   #spicetifyPackage = pkgs.unstable.spicetify-cli;
  #   enabledExtensions = with spicetify-pkgs.extensions; [
  #     fullAppDisplay
  #   ];
  # theme = spicetify-pkgs.themes.hazy;

  #   theme = {
  #     name = "hazy"; # text
  #     injectCss = true;
  #     injectThemeJs = true;
  #     replaceColors = true;
  #     overwriteAssets = true;
  #     src = pkgs.fetchFromGitHub {
  #       owner = "Astromations";
  #       repo = "Hazy";
  #       rev = "e037ffc";
  #       hash = "sha256-50ZhlMcS//0cgbTiMQMMgSJfWlPo8lc9UrqKzIuV+X4=";
  #     };
  #   };
  # };
}
