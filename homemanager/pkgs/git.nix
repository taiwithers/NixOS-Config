{ pkgs, ... }:
{
  imports = [ ./common-git.nix ];
  programs.git = {
    enable = true;
    signing.key = "/home/tai/.ssh/id_ed25519_github.pub";
    signing.signByDefault = true;
    userEmail = "59430904+taiwithers@users.noreply.github.com";
    userName = "taiwithers";
    extraConfig = {
      gpg.format = "ssh";
      pull.rebase = "false";
      init.defaultBranch = "main";
      core.whitespace.trailing-space = false;
      credential.credentialStore = "cache";
      # credential.helper = "${pkgs.git-credential-manager}/lib/git-credential-manager/git-credential-manager";
      diff.context = 1;
      diff.renames = true;
      difftool.prompt = true; # ??
      diff.tool = "nvimdiff";
      status.relativePaths = false;
      # ignore-space-at-eol = true;
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
