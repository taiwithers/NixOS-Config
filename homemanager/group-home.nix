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
    signing.key = "${homeDirectory}/.ssh/id_ed25519_github.pub";
    extraConfig = {
      credential.helper = "${homeDirectory}/miniconda3/envs/qstar-env/bin/gh auth git-credential";
      gpg.format = "ssh";
      credential.credentialStore = "gpg";
      core.autocrlf = "input";
      filter.lfs = {
        clean = "git-lfs clean -- %f";
      };
    };
  };

  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  home.stateVersion = "24.05";
  targets.genericLinux.enable = true;
}
