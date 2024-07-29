{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  app-themes,
  ...
}:
{
  imports = map (fname: import ./pkgs/${fname}.nix { inherit config pkgs app-themes; }) [
    "bash"
    "bat"
    "bottom"
    "cod"
    "common-git"
    "duf"
    "dust"
    "eza"
    "fzf"
    "lazygit"
    "python/python"
    "starship"
    "superfile"
    "zoxide"
  ];
  home.packages = with pkgs; [
    fastfetch
    fd
    nix-output-monitor
    nixfmt
    ripgrep
    trashy
    xdg-ninja
  ];

  # programs.bash.bashrcExtra = builtins.readFile ./group-bashrc.sh;
  programs.bash.bashrcExtra = ''
    # add texlive to path
    export PATH=/home/twithers/opt/texlive/2023/bin/x86_64-linux:$PATH
    export GPG_TTY=/dev/pts/0
  '';

  programs.git = {
    signing.key = "${config.home.homeDirectory}/.ssh/id_ed25519_github.pub";
    extraConfig = {
      credential.helper = "${config.home.homeDirectory}/miniconda3/envs/qstar-env/bin/gh auth git-credential";
      gpg.format = "ssh";
      credential.credentialStore = "gpg";
      core.autocrlf = "input";
      filter.lfs = {
        clean = "git-lfs clean -- %f";
      };
    };
  };

  home.shellAliases = {
    "rebuild" = "home-manager switch --impure --show-trace --flake ~/.config/NixOS-Config/homemanager |& nom";
  };

  nix.package = pkgs.lix;
  home.stateVersion = "24.05";
}
