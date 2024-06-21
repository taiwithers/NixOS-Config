{
  config,
  pkgs,
  theme-config,
  ...
}: let
  fzfThemeDirectory = "${config.xdg.configHome}/fzf-themes/";
  fzfDefaultOptions = [
    "--layout reverse"
    "--height ~60%"
    "--border sharp"
    "--margin 0,3%"
    "--info inline"
    "--tabstop 4"
  ];
  previewFile = "${config.xdg.configHome}/fzf-preview.sh";
  fzfPreviewOptions = ["--preview '${previewFile} {}'" "--preview-window border-sharp"];
in {
  programs.fzf = rec {
    enable = true;
    colors = {};

    # typing "fzf" as a command
    defaultCommand = "fd --type file --type symlink";
    defaultOptions = fzfDefaultOptions ++ fzfPreviewOptions;

    # alt-c
    changeDirWidgetCommand = "fd --type directory";
    changeDirWidgetOptions = fzfDefaultOptions;

    # ctrl-t
    fileWidgetCommand = defaultCommand;
    fileWidgetOptions = defaultOptions;

    # ctrl-r
    historyWidgetOptions = fzfDefaultOptions;
  };

  xdg.configFile."${previewFile}".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/junegunn/fzf/master/bin/fzf-preview.sh";
    sha256 = "FwvZj1lwc08ir23XOehB34giidd5/tyjVYHdA8TUTQE=";
    executable = true;
  };

  # download all base 16 themes to fzf theme directory
  xdg.configFile."${fzfThemeDirectory}".source = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinted-fzf";
    rev = "87368a6";
    hash = "sha256-Lo5++1pOD9i62ahI3Ta2s/F/U80LXOu0sWMLUng3GbQ=";
  };

  programs.bash.bashrcExtra =
    let
      getThemePath = name: "${fzfThemeDirectory}/sh/base16-${name}.sh";
      fzfThemeName = theme-config.selectAvailableTheme getThemePath;
    in (
      if (builtins.stringLength fzfThemeName) == 0
      then ""
      else "source ${getThemePath fzfThemeName}"
    )
    # + "\nchmod +x ${previewFile}"
    ;
}
