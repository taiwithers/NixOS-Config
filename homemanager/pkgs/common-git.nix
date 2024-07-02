{pkgs, ...}: {
  programs.git = {
    enable = true;
    signing.signByDefault = true;
    userEmail = "59430904+taiwithers@users.noreply.github.com";
    userName = "taiwithers";
    extraConfig = {
      pull.rebase = "false";
      init.defaultBranch = "main";
      core.whitespace.trailing-space = false;
      diff.context = 1;
      diff.renames = true;
      status.relativePaths = false;
    };
    delta = {
      enable = true;
      options = {
        dark = true;
        side-by-side = true;
        hunk-header-style = "omit";
        line-numbers-left-format = "{nm}│"; # not pipes! taller!
        line-numbers-right-format = "{np}│";
        tabs = 4;
        syntax-theme = "base16";
        hyperlinks = true;
      };
    };
  };
}
