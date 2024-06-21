{
  config,
  pkgs,
  theme-config,
  ...
}: let
  fzfThemeDirectory = "${config.xdg.configHome}/fzf-themes/";
  previewFile = "${config.xdg.configHome}/fzf-preview.sh";
in {
  programs.fzf = rec {
    enable = true;
    colors = {};

    # typing "fzf" as a command
    defaultCommand = "fd --type f";
    defaultOptions = [
      "--layout reverse"
      "--height ~60%"
      "--border sharp"
      "--preview '${previewFile} {}'"
      "--margin 0,1%"
      "--info inline"
      "--tabstop 4"
      "--preview-window border-sharp"
    ];

    # alt-c
    changeDirWidgetCommand = "";
    changeDirWidgetOptions = [];

    # ctrl-t
    fileWidgetCommand = defaultCommand;
    fileWidgetOptions = defaultOptions;

    # ctrl-r
    historyWidgetOptions = defaultOptions;
  };

  xdg.configFile."${previewFile}".source = builtins.fetchurl "https://raw.githubusercontent.com/junegunn/fzf/master/bin/fzf-preview.sh";

  # download all base 16 themes to fzf theme directory
  xdg.configFile."${fzfThemeDirectory}".source = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinted-fzf";
    rev = "87368a6";
    hash = "sha256-Lo5++1pOD9i62ahI3Ta2s/F/U80LXOu0sWMLUng3GbQ=";
  };

  programs.bash.bashrcExtra = let
    getThemePath = name: "${fzfThemeDirectory}/sh/base16-${name}.sh";
    fzfThemeName = theme-config.selectAvailableTheme getThemePath;
  in (
    if (builtins.stringLength fzfThemeName) == 0
    then ""
    else "source ${getThemePath fzfThemeName}"
  );
}
