{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  ...
}: let
  app-themes = with (import ../scripts/theme-config.nix {
    inherit pkgs;
    inherit (flake-inputs) arc;
  }); let
    defaultTheme = "base16/da-one-ocean";
  in {
    palettes = makePaletteSet {superfile = defaultTheme;};
    filenames = makePathSet {fzf = defaultTheme;};
  };

  homeDirectory = "/home/${user}";
in {
  imports = map (fname: import ./pkgs/${fname}.nix {inherit config pkgs theme-config;}) [
    "bottom"
    "starship"
    "superfile"
    "eza"
    "fzf"
    "common-git"
    "bat"
    "lazygit"
  ];
  home.packages = with pkgs; let
    superfile = flake-inputs.superfile.packages.${system}.default;
  in [
    alejandra
    cod
    dust
    fastfetch
    fd
    fzf
    superfile
    trashy
    xdg-ninja
  ];

  programs.bash = {
    enable = true;
    bashrcExtra = builtins.readFile ./group-bashrc.sh;
    shellAliases = {
      brc = "source ~/.bashrc";
    };
  };

  programs.git = {
    signing.key = "${homeDirectory}/.ssh/id_ed25519_github.pub";
    extraConfig = {
      credential.helper = "${homeDirectory}/miniconda3/envs/qstar-env/bin/gh auth git-credential";
      # credential.helper = "/usr/local/share/gcm-core/git-credential-manager-core";
      gpg.format = "ssh";
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
  };

  nixpkgs.config = pkgs-config;
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  home.username = user;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
