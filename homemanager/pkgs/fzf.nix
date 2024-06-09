{
  config,
  pkgs,
  theme-config,
  ...
}: let
  fzfThemeDirectory = "${config.xdg.configHome}/fzf-themes/";
in {
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--height=60%"
      "--border=sharp"
      "--preview 'bat {}'"
      "--preint-query"
    ];
  };

  # download all base 16 themes to fzf theme directory
  xdg.configFile."${fzfThemeDirectory}".source = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinted-fzf";
    rev = "87368a6";
    hash = "sha256-Lo5++1pOD9i62ahI3Ta2s/F/U80LXOu0sWMLUng3GbQ=";
  };

  programs.bash.bashrcExtra = let
    getThemePath = name: "${fzfThemeDirectory}/sh/base16-${name}.sh";
    fzfTheme = getThemePath (theme-config.selectAvailableTheme getThemePath);
  in (
    if (builtins.stringLength fzfTheme) == 0
    then ""
    else "source ${fzfTheme}"
  );
}
