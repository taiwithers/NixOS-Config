{
  config,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    signing.key = "${config.home.homeDirectory}/.ssh/id_ed25519_github.pub";
    signing.signByDefault = true;
    userEmail = "59430904+taiwithers@users.noreply.github.com";
    userName = "taiwithers";
    extraConfig = {
      core.autocrlf = "input";
      core.eol = "lf";
      core.fileMode = false;
      core.whitespace.trailing-space = false;
      diff.context = 1;
      diff.renames = true;
      filter.lfs = {
        clean = "gid-lfs clean -- %f";
      };
      gpg.format = "ssh";
      init.defaultBranch = "main";
      pull.rebase = "true";
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

  programs.ssh = {
    enable = true;
    matchBlocks."github.com" = {
      hostname = "github.com";
      user = "git";
      identityFile = "${config.home.homeDirectory}/.ssh/id_ed25519_github";
    };
  };
}
