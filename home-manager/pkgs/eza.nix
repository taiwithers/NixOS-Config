_: {
  programs.eza = {
    enable = true; # aliases eza to eza-with-options, and adds ls & friends
    extraOptions = [
      # filtering
      "--long"
      "--all"

      # information style
      "--header"
      "--hyperlink"
      "--group-directories-first"
      "--time-style=iso"
      "--icons=auto"
      "--color=always"

      # information content
      "--no-user"
      "--git"
      # "--no-permissions"
    ];
  };

  home.shellAliases = {
    # explicitly list those added by programs.eza.enable = true
    # unless noted these are of the same form as .enable makes them
    # just using long form options
    "ls" = "eza --git-ignore"; # added gitignore
    "ll" = "eza --long";
    "la" = "eza --all";
    "lt" = "eza --tree";
    "lla" = "eza --all --long";

    # new
    "tree" = "eza --tree --git-ignore";
  };
}
