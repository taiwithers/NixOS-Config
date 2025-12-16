{ ... }:
{
  imports = [ ./common-git.nix ];
  programs.git = {
    enable = true;
    settings = {
      credential.credentialStore = "cache";
      # credential.helper = "${pkgs.git-credential-manager}/lib/git-credential-manager/git-credential-manager";
      merge.tool = "nvimdiff";
    };
  };
}
