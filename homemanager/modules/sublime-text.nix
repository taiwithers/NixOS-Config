{
  config,
  pkgs,
  ...
}: let
  packagesPath = "${config.xdg.configHome}/sublime-text/Packages/User";
  packages = [
    {
      owner = "wbond";
      repo = "package_control";
      rev = "4.0.6";
      hash = "sha256-aaVm0F2hVeVvySKXWuirF7hwm7VQbGExzoJsz9VcIKY=";
      # hash = "sha256-aaVm0F2hVeVvySKXWuirF7hwm7VQbGExzoJsz9VcIKY=";
      # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    }
    # {
    #   owner = "ThomasKliszowski";
    #   repo = "json_reindent";
    #   rev = "2.0.4";
    #   hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjsonreindent="; # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    # }
    # {
    #   owner = "titoBouzout";
    #   repo = "SideBarEnhancements";
    #   rev = "12.0.4"; #
    #   hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAsidebarenhan="; # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    # }
    # {
    #   owner = "SublimeText";
    #   repo = "AFileIcon";
    #   rev = "3.27.0";
    #   hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAfileicon="; # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    # }
    # {
    # 	owner = "kemayo";
    # 	repo = "sublime-text-git";
    # 	rev = "latest"; # f649fe4 / f649fe4ba657ce9c132cadb91f97c6f8d98834c2
    # 	hash = "";  # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    # }
    # {
    #   owner = "SublimeText";
    #   repo = "Origami";
    #   rev = "7369b11"; #  / 7369b117290d72629cf2d226e90998b8ec22fb82
    #   hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAorigami="; # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
    # }
    # {
    # 	owner = "";
    # 	repo = "";
    # 	rev = "latest";
    # 	hash = "";  # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
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

  # xdg.configFile results in source already defined...?
  # home.file."${packagesPath}/Preferences.sublime-settings".source = ./non-nix/Preferences.sublime-settings;
  # home.file."${packagesPath}/Default.sublime-keymap".source = ./non-nix/Default.sublime-keymap;
}
