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

  programs.bash.bashrcExtra = ''
    # add texlive to path
    export PATH=/home/twithers/opt/texlive/2023/bin/x86_64-linux:$PATH
    export GPG_TTY=/dev/pts/0
  '';

  programs.git = {
    extraConfig = {
      credential.credentialStore = "gpg";
    };
  };

  home.shellAliases = {
    "rebuild" = "home-manager switch --impure --show-trace --flake ~/.config/NixOS-Config/homemanager |& nom";
  };
  nix.package = pkgs.lix;
  home.stateVersion = "24.05";
}
