{
  config,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    signing.key = "${config.common.userHome}/.ssh/id_ed25519_github.pub";
    signing.signByDefault = true;
    settings = {
    user.name = "taiwithers";
    user.email = "59430904+taiwithers@users.noreply.github.com";

      branch.sort = "-committerdate";

      core.attributesfile = "${config.common.configHome}/git/attributes";
      core.autocrlf = "input";
      core.eol = "lf";
      core.fileMode = false;
      core.whitespace.trailing-space = false;

      diff.context = 1;
      diff.renames = true;

      filter.lfs.clean = "git-lfs clean -- %f";

      gpg.format = "ssh";

      grep.lineNumber = true;
      grep.patternType = "perl";

      help.autocorrect = "prompt"; # check for typos in commands and offer to run the corrected version

      init.defaultBranch = "main";

      pull.rebase = "true";

      push.autoSetupRemote = true; # automatically create remote branches

      rerere.autoUpdate = true;
      rerere.enabled = true; # record conflict resolutions

      status.relativePaths = false;

      # "url \"git@github.com:\"".insteadOf = "https://github.com";
      diff.exiftool.textconv = "exiftool";

    alias = {
      fpush = "push --force-with-lease"; # safer force push
      lastcommit = "log --max-count=1 --format=%h --abbrev-commit"; # get the short hash of the last commit - for e.g., `cloc $(git lastcommit)`
      };
    };

    attributes = [
      "*.png diff=exiftool"
      "*.pdf diff=exiftool"
      "*.gif diff=exiftool"
    ];
    ignores = [
      "__pycache__"
      "*.ipynb_checkpoints"
      ".direnv"
      "*:Zone.Identifier"
    ];

    maintenance = {
      enable = true;
    };

    lfs.enable = true;
  };

    programs.delta = {
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
  programs.ssh = {
    matchBlocks."github.com" = {
      hostname = "github.com";
      user = "git";
      identityFile = "${config.home.homeDirectory}/.ssh/id_ed25519_github";
    };
    matchBlocks."codeberg.org" = {
      hostname = "codeberg.org";
      user = "git";
      identityFile = "${config.home.homeDirectory}/.ssh/id_ed25519_github";
    };
  };

  home.shellAliases."gitstatus" = ''
    onefetch --no-art --no-color-palette --no-title --disabled-fields authors languages churn created project pending head commits && git status --short --branch
  '';
  home.packages = with pkgs; [
    onefetch
    exiftool
  ];

}
