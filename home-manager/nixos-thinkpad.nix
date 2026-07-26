{
  config,
  pkgs,
  flake-inputs,
  colours,
  ...
}:
{
  # nixos-rebuild switch --install-bootloader --use-remote-sudo --flake ./path-to-flake#output-name
  # nix run home-manager/release-24.11 -- switch --impure --flake ./path-to-flake#output-name
  imports = [
    # (import ./pkgs/agenix/agenix.nix {
    #   inherit config pkgs;
    #   inherit (flake-inputs) agenix;
    # })

    (import ./themeing.nix {
      inherit config;
      inherit pkgs;
      inherit (flake-inputs) stylix;
    })

    (import ./pkgs/niri.nix {
      inherit config;
      inherit pkgs;
      inherit (flake-inputs) niri;
    })

  ]
  ++ (map
    (
      fname:
      import (./. + "/pkgs/${fname}.nix") {
        inherit
          config
          pkgs
          colours
          ;
      }
    )
    [
      "bash"
      "bat"
      # "blesh" # uses colours
      "bottom"
      "cod"
      "duf"
      "dust"
      "dunst"
      "eza"
      "firefox/firefox"
      "fzf"
      "git" # also installed system-wide
      "kitty"
      "lazygit"
      "neovim/neovim"
      "ripgrep"
      "rofi/rofi" # uses colours
      "starship"
      "tldr"
      "yazi"
      "zellij"
      "zoxide"
    ]
  );
  home.packages = with pkgs; [
    # nix programs
    nix-output-monitor # sudo nixos-rebuild [usual options] |& nom
    nix-search-tv

    cloc
    dconf
    fastfetch
    jq
    bluetui

    discord
  ];

  programs.bash.bashrcExtra = ''
    # add completions
    complete -F _command get-package-path
    complete -F _command whichl
  '';

  systemd.user.services."ac-power-monitor" = {
    Unit.Description = "Notify when charging cable is (dis)connected";
    Install.WantedBy = [ "default.target" ]; # needed or else it  won't actually be started
    Service.ExecStart = "${pkgs.ac-power-monitor}/bin/ac-power-monitor";
  };

  common.nixConfigDirectory = "${config.home.homeDirectory}/Nix";
  common.useXDG = true;
  common.nixos = true;

  home.stateVersion = "25.11";
}
