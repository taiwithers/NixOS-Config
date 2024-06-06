# https://github.com/SublimeText/PackageDev
{
  config,
  pkgs,
  theme-config,
  ...
}: let
  packagesPath = "${config.xdg.configHome}/sublime-text/Packages/User";
  packages = [
    {
      name = "Package Control";
      function = pkgs.fetchFromGitHub;
      owner = "wbond";
      repo = "package_control";
      rev = "4.0.6";
      hash = "sha256-Ep46FhcPOxND+U/fjAHz/+qDseik7/pPxTARY0EGe9o=";
      # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    }
    {
      name = "JSON Reindent";
      function = pkgs.fetchFromGitHub;
      owner = "ThomasKliszowski";
      repo = "json_reindent";
      rev = "2.0.4";
      hash = "sha256-aaVm0F2hVeVvySKXWuirF7hwm7VQbGExzoJsz9VcIKY="; # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    }
    {
      name = "SideBarEnhancements";
      function = pkgs.fetchFromGitHub;
      owner = "titoBouzout";
      repo = "SideBarEnhancements";
      rev = "12.0.4"; #
      hash = "sha256-FzhC691BQI5XnYfMHft39Wz1Mu+AYvegfrF0VPwRRxE="; # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    }
    {
      name = "Nix";
      function = pkgs.fetchFromGitHub;
      owner = "wmertens";
      repo = "sublime-nix";
      rev = "9032bd6";
      hash = "sha256-ojb9xg26OL0kOZfcYXWIIS0efpHPFwlIwKklclmrUTc="; # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    }
    {
      name = "Tinted Theming";
      function = pkgs.fetchFromGitHub;
      owner = "tinted-theming";
      repo = "tinted-sublime-text";
      rev = "e001ce1";
      hash = "sha256-S41mxSCAbERUdhaaKZYb7tr1mkE84a3fekTY70r5LL4=";
    }
    {
      name = "TOML";
      function = pkgs.fetchFromGitHub;
      owner = "jasonwilliams";
      repo = "sublime_toml_highlighting";
      rev = "fd0bf3e";
      hash = "sha256-/9RCQNWpp2j/u4o6jBCPN3HEuuR4ow3h+0Zj+Cbteyc=";
    }
    # {
    #   name = "SFTP";
    #   function = path: "${config.xdg.configHome}/sublime-text/Packages/User/SFTP_Manual";
    #   url = "https://codexns.io/packages/sftp/2.0.0-st4-posix/SFTP.sublime-package";
    #   hash = "";
    # }
    # {
    # 	owner = "";
    # 	repo = "";
    # 	rev = "latest";
    # 	hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    # }
  ];
in {
  # download packages to .config/ST/Packages/User
  home.file = builtins.listToAttrs (map (package: {
      name = "${packagesPath}/${
        if builtins.hasAttr "repo" package
        then package.repo
        else package.name
      }";
      value = {source = package.function (builtins.removeAttrs package ["function" "name"]);};
    })
    packages);

  # download Package Control.sublime-package to .config/ST/Installed Packages/
  xdg.configFile."${config.xdg.configHome}/sublime-text/Installed Packages/Package Control.sublime-package" = {
    enable = false; # only do this once
    source = pkgs.fetchurl {
      url = "https://packagecontrol.io/Package%20Control.sublime-package";
      hash = "sha256-gXk3FEw0yEyIzUO4UxiyZW+cP6wC+PcsvBg2Cywm0Tk=";
    };
  };

  # list installed packages in .config/ST/Packages/User/Package Control.sublime-settings
  xdg.configFile."${packagesPath}/Package Control.sublime-settings".text = ''
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

  xdg.configFile."${packagesPath}/Default.sublime-theme".text = ''{"variables": {}, "rules": [] } '';
  xdg.configFile."${packagesPath}/Default.sublime-keymap".text = ''[{ "keys": ["ctrl+shift+n"], "command": "new_window" }]'';
  xdg.configFile."${packagesPath}/Preferences.sublime-settings".text = let
    getThemePath = name: "${packagesPath}/tinted-sublime-text/base16-${name}.sublime-theme";
    sublimeTheme = theme-config.selectAvailableTheme getThemePath;
    getColourSchemePath = name: "${packagesPath}/tinted-sublime-text/color-schemes/base16-${name}.sublime-color-scheme";
    sublimeColourScheme = theme-config.selectAvailableTheme getColourSchemePath;
  in ''
    {
      "ignored_packages":
      [
        "Vintage",
      ],
      "font_size": 11,
      "color_scheme": "base16-${sublimeColourScheme}.sublime-color-scheme",
      "theme": "Adaptive.sublime-theme",
    }
  '';

  # xdg.configFile."${packagesPath}/yuck.tmLanguage".source = ./yuck.tmLanguage;
  xdg.configFile."${packagesPath}/yuck.sublime-syntax".source = ./yuck.sublime-syntax;
}
