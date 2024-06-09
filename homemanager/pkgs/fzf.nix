{
  config,
  pkgs,
  selectAvailableTheme,
}: {
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
  xdg.configFile."${config.xdg.configHome}/fzf-themes/".source = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "tinted-fzf";
    rev = "87368a6";
    hash = "sha256-Lo5++1pOD9i62ahI3Ta2s/F/U80LXOu0sWMLUng3GbQ=";
  };
  programs.bash.bashrcExtra = let
    getThemePath = name: "${config.xdg.configHome}/fzf-themes/sh/base16-${name}.sh";
    fzfTheme = getThemePath (selectAvailableTheme getThemePath);
  in "source ${fzfTheme}";
}
