{ pkgs, ... }:
{
  imports = [ ./common-git.nix ];
  programs.git = {
    enable = true;
    extraConfig = {
      credential.credentialStore = "cache";
      # credential.helper = "${pkgs.git-credential-manager}/lib/git-credential-manager/git-credential-manager";
      merge.tool = "nvimdiff";
    };
  };
}
