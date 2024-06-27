{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  ...
}: let
  theme-config = import ./theme-config.nix {inherit (flake-inputs) nix-colors;};
  homeDirectory = "/home/${user}";
in {
  imports = map (fname: import ./pkgs/${fname}.nix {inherit config pkgs theme-config;}) [
    "bottom/bottom"
    "starship/starship"
    "superfile/superfile"
    "eza"
    "fzf"
    "common-git"
    "bat"
    "lazygit"
  ];
  home.packages = with pkgs; [
    alejandra
    cod
    dust
    fastfetch
    trashy
    xdg-ninja
    flake-inputs.superfile.packages.${system}.default
  ];

  programs.bash = {
    enable = true;
    bashrcExtra = builtins.readFile ./group-bashrc.sh;
    shellAliases = {brc = "source ~/.bashrc";};
  };

  programs.git = {
    signing.key = "${homeDirectory}/.ssh/id_ed25519_github.pub";
    extraConfig = {
      credential.helper = "${homeDirectory}/miniconda3/envs/qstar-env/bin/gh auth git-credential";
      # credential.helper = "/usr/local/share/gcm-core/git-credential-manager-core";
      credential.credentialStore = "gpg";
      core.autocrlf = "input";
      filter.lfs = {
        clean = "git-lfs clean -- %f";
      };
    };
  };

  home.shellAliases = let
    bashScripts = "${config.xdg.configHome}/NixOS-Config/scripts";
  in {
    # use new programs
    "grep" = "echo 'Consider using ripgrep [rg] or batgrep instead'";
    "du" = "echo 'Consider using dust instead'";
    "df" = "echo 'Consider using duf instead'";
    "ls" = "eza";
    "tree" = "eza --tree";
    "man" = "batman --no-hyphenation --no-justification";

    # simplify commands
    "untar" = "tar -xvf";
    "confdir" = "cd ~/.config/NixOS-Config";
    "dust" = "dust --reverse";

    # personal bash scripts -> move these to pkgs.writeShellScriptBin
    "rebuild" = "bash ${bashScripts}/rebuild.sh";
    "get-package-dir" = "bash ${bashScripts}/get-package-dir.sh";
    "search" = "bash ${bashScripts}/nix-search-wrapper.sh";
    "gmv" = "bash ${bashScripts}/git-mv.sh";
  };

  nixpkgs.config = pkgs-config;
  nix.package = pkgs.nix;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  home.username = user;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
