{...}: {
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
      core.whitespace.blank-at-eol = false;
      core.whitespace.blank-at-eof = false;
      credential.credentialStore = "cache";
      # ignore-space-at-eol = true;
    };
    delta = {
      enable = true;
      options = {
        dark = true;
        side-by-side = true;
        hunk-header-style = "omit";
        tabs = 4;
        syntax-theme = "base16";
      };
    };
  };
}
