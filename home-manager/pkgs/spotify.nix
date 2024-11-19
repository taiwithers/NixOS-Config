{
    config, pkgs, spicetify-nix, ...
  }:
  {
      imports = [ spicetify-nix.homeManagerModules.default ];
      
  programs.spicetify = {
    enable = true;
    spicetifyPackage = pkgs.unstable.spicetify-cli;
    enabledExtensions = with spicetify-nix.legacyPackages.${pkgs.system}.extensions; [
      fullAppDisplay
    ];
  };
    }
