{
  config,
  pkgs,
  colourScheme,
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
    {
      owner = "chriskempson";
      repo = "base16-textmate";
      rev = "0e51ddd";
      hash = "sha256-reYGXrhhHNSp/1k6YJ2hxj4jnJQCDgy2Nzxse2PviTA=";
    }
    # {
    # 	owner = "";
    # 	repo = "";
    # 	rev = "latest";
    # 	hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    # }
  ];
in {
  # download packages to .config/ST/Packages/User
  xdg.configFile = builtins.listToAttrs (map (package: {
      name = "${packagesPath}/${package.repo}";
      value = {source = pkgs.fetchFromGitHub package;};
    })
    packages);

  # download Package Control.sublime-package to .config/ST/Installed Packages/
  home.file."${config.xdg.configHome}/sublime-text/Installed Packages/Package Control.sublime-package".source = pkgs.fetchurl {
    url = "https://packagecontrol.io/Package%20Control.sublime-package";
    hash = "sha256-gXk3FEw0yEyIzUO4UxiyZW+cP6wC+PcsvBg2Cywm0Tk=";
  };

  # list installed packages in .config/ST/Packages/User/Package Control.sublime-settings
  home.file."${packagesPath}/Package Control.sublime-settings".text = ''
    {
      "bootstrapped": true,
      "installed_packages": [
      	${builtins.concatStringsSep ",\n\t" (
      map (name: "\"${name}\"") (builtins.catAttrs "name" packages)
    )}
        ],
      "in_process_packages": [],
    }
  '';

  home.file = {
    "${packagesPath}/Default.sublime-theme".text = ''
          {
        "variables":
        {
          "sidebar_bg": "#FFFFFF"
        },
        "rules":
        [

        ]
      }
    '';
  };
  # home.file."${packagesPath}/Preferences.sublime-settings".source = ./non-nix/Preferences.sublime-settings;
  # home.file."${packagesPath}/Default.sublime-keymap".source = ./non-nix/Default.sublime-keymap;
}
