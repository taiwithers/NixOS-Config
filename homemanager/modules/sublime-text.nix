{
  config,
  pkgs,
  ...
}: let
  packagesPath = "${config.xdg.configHome}/sublime-text/Packages/User";
  packages = [
    {
      name = "Package Control";
      owner = "wbond";
      repo = "package_control";
      rev = "4.0.6";
      hash = "sha256-Ep46FhcPOxND+U/fjAHz/+qDseik7/pPxTARY0EGe9o=";
      # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    }
    {
      name = "JSON Reindent";
      owner = "ThomasKliszowski";
      repo = "json_reindent";
      rev = "2.0.4";
      hash = "sha256-aaVm0F2hVeVvySKXWuirF7hwm7VQbGExzoJsz9VcIKY="; # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    }
    {
      name = "SideBarEnhancements";
      owner = "titoBouzout";
      repo = "SideBarEnhancements";
      rev = "12.0.4"; #
      hash = "sha256-FzhC691BQI5XnYfMHft39Wz1Mu+AYvegfrF0VPwRRxE="; # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    }
    {
      name = "Nix";
      owner = "wmertens";
      repo = "sublime-nix";
      rev = "9032bd6";
      hash = "sha256-ojb9xg26OL0kOZfcYXWIIS0efpHPFwlIwKklclmrUTc="; # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    }
    # {
    # 	owner = "";
    # 	repo = "";
    # 	rev = "latest";
    # 	hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    # }
  ];
in {
  # either of these should work i'm pretty sure?
  xdg.configFile = builtins.listToAttrs (map (package: {
      name = "${packagesPath}/${package.repo}";
      value = {source = pkgs.fetchFromGitHub package;};
    })
    packages);
  # xdg.configFile = map ( "${packagesPath}/${package.repo}".source: pkgs.fetchFromGithub package ) packages;

  home.file."${config.xdg.configHome}/sublime-text/Installed Packages/Package Control.sublime-package".source = pkgs.fetchurl {
    url = "https://packagecontrol.io/Package%20Control.sublime-package";
    hash = "sha256-gXk3FEw0yEyIzUO4UxiyZW+cP6wC+PcsvBg2Cywm0Tk=";
  };

  home.file."testoutput".text = ''
    ${builtins.concatStringsSep "," (map (name: "${name}") (builtins.catAttrs "name" packages))}
  '';

  # xdg.configFile results in source already defined...?
  # home.file."${packagesPath}/Preferences.sublime-settings".source = ./non-nix/Preferences.sublime-settings;
  # home.file."${packagesPath}/Default.sublime-keymap".source = ./non-nix/Default.sublime-keymap;
}
