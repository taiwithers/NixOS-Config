{
  config,
  pkgs,
  app-themes,
  ...
}: let
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

  # source theme in bashrc
  programs.bash.bashrcExtra = let
    fzfThemes = pkgs.fetchFromGitHub {
      owner = "tinted-theming";
      repo = "tinted-fzf";
      rev = "87368a6";
      hash = "sha256-Lo5++1pOD9i62ahI3Ta2s/F/U80LXOu0sWMLUng3GbQ=";
    };
    themePath = "${fzfThemes}/sh/${app-themes.filenames.fzf}.sh";
  in "source ${themePath}";
}
