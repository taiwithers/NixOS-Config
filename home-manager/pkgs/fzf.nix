{
  config,
  pkgs,
  ...
}:
let
  fzfDefaultOptions = [
    "--layout reverse"
    "--height '~60%'"
    "--border sharp"
    "--margin 0,3%"
    "--info inline"
    "--tabstop 4"
  ];
  fzfPreviewOptions = [
    "--preview-window border-sharp"
  ];
in
{
  # home.packages = [pkgs.fzf];
  programs.fzf = rec {
    enable = true;
    colors = { };

    # typing "fzf" as a command
    defaultCommand = "fd --type file --type symlink";
    defaultOptions = fzfDefaultOptions;

    # alt-c
    changeDirWidgetCommand = "fd --type directory";
    changeDirWidgetOptions = fzfDefaultOptions;

    # ctrl-t
    fileWidgetCommand = defaultCommand;
    fileWidgetOptions = defaultOptions;

    # ctrl-r
    historyWidgetOptions = fzfDefaultOptions;
  };
}
