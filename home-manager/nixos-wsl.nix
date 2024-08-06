{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  app-themes,
  fonts,
  ...
}: {
  imports = map (fname: import ./pkgs/${fname}.nix {inherit config pkgs app-themes;}) [
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
    "neovim/neovim"
    "starship"
    "superfile"
    "zoxide"
  ];

  common.nixConfigDirectory = "/mnt/c/Users/tai/Documents/Git/NixOS-Config";
  common.useXDG = true;
  common.nixos = true;

  home.packages = with pkgs; [
    age
    # agenix
    cbonsai
    fastfetch
    fd
    nix-output-monitor
    pond
    ripgrep
    ripgrep-all
    shellcheck
    starfetch
    trashy
    xdg-ninja
    zellij
  ];

  home.shellAliases = {
    "rebuild" = "home-manager switch --impure --show-trace --flake ${config.common.nixConfigDirectory}/homemanager |& nom";
    "bsession" = "bat ${config.common.hm-session-vars}";
  };
  home.stateVersion = "24.05";
}
