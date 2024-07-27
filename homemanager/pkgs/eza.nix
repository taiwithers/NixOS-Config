{ ... }:
{
  programs.eza = {
    enable = true;
    extraOptions = [
      "--long"
      "--colour=always"
      "--hyperlink"
      "--all"
      "--group-directories-first"
      "--header"
      "--time-style=iso"
      "--no-permissions"
      "--no-user"
    ];
    git = true;
    icons = true;
  };

  home.shellAliases = {
    "ls" = "eza";
    "tree" = "eza --tree";
  };
}
