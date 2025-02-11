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
    userEmail = "59430904+taiwithers@users.noreply.github.com";
    userName = "taiwithers";
    extraConfig = {
      branch.sort = "-committerdate";
      core.attributesfile = "${config.common.configHome}/git/attributes";
      core.autocrlf = "input";
      core.eol = "lf";
      core.fileMode = false;
      core.whitespace.trailing-space = false;
      diff.context = 1;
      diff.renames = true;
      filter.lfs = {
        clean = "git-lfs clean -- %f";
      };
      gpg.format = "ssh";
      init.defaultBranch = "main";
      pull.rebase = "true";
      rerere.enabled = true; # record conflict resolutions
      rerere.autoUpdate = true;
      status.relativePaths = false;
      push.autoSetupRemote = true; # automatically create remote branches

      diff.exiftool.textconv = "exiftool";

    };
    aliases = {
      fpush = "push --force-with-lease"; # safer force push
    };
    attributes = [
      "*.png diff=exiftool"
      "*.pdf diff=exiftool"
    ];
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
    ignores = [
      ".direnv"
    ];

    maintenance = {
      enable = true;
    };

    lfs.enable = true;
  };

  programs.ssh = {
    enable = true;
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
