_: {
  programs.eza = {
    enable = true;
    extraOptions = [
      "--long"
      "--hyperlink"
      "--all"
      "--group-directories-first"
      "--header"
      "--time-style=iso"
      # "--no-permissions"
      "--no-user"
    ];
    git = true;
    icons = "auto";
    colors = "always";
  };

  home.shellAliases = {
    "ls" = "eza";
    "tree" = "eza --tree";
  };
}
