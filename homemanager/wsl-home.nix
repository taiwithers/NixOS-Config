{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  ...
}:
let
  app-themes =
    with (import ../scripts/theme-config.nix {
      inherit pkgs;
      inherit (flake-inputs) arc;
    });
    let
      defaultTheme = "base16/da-one-ocean";
    in
    {
      palettes = makePaletteSet { superfile = defaultTheme; };
      filenames = makePathSet { fzf = defaultTheme; };
    };

  shell-scripts = builtins.attrValues (
    builtins.mapAttrs
      (name: fname: pkgs.writeShellScriptBin name (builtins.readFile ../scripts/${fname}.sh))
      {
        get-package-dir = "get-package-dir";
        gmv = "git-mv";
        clean = "clean";
      }
  );

  homeDirectory = "/home/${user}";
in
{
  imports = map (fname: import ./pkgs/${fname}.nix { inherit config pkgs app-themes; }) [
    "bat"
    "bottom"
    "common-git"
    "eza"
    "fzf"
    "lazygit"
    "neovim/neovim"
    "starship"
    "superfile"
  ];
  home.packages =
    with pkgs;
    [
      cbonsai
      cod
      duf
      dust # view specific info for directories
      fastfetch
      fd
      fzf
      gcc
      gnumake
      nixfmt
      nix-output-monitor
      pond
      ripgrep
      ripgrep-all
      shellcheck
      superfile
      trashy
      xdg-ninja
      zellij
      zoxide
    ] ++ shell-scripts ++ [(pkgs.writeShellApplication {
              name = "search";
              runtimeInputs = [nix nix-search-cli jq sd ];
              excludeShellChecks = ["SC2046" "SC2155" "SC2086" "SC2116" "SC2005" "SC2162"];
              text = builtins.readFile ../scripts/nix-search-wrapper.sh;
            })];

  programs.bash = {
    enable = true;
    bashrcExtra = builtins.readFile ./wsl-bashrc.sh;
    shellAliases = {
      brc = "source ~/.bashrc";
    };
  };

  programs.git = {
    signing.key = "~/.ssh/id_ed25519_github";
    extraConfig = {
      # credential.helper = "${homeDirectory}/miniconda3/envs/qstar-env/bin/gh auth git-credential";
      # credential.helper = "/usr/local/share/gcm-core/git-credential-manager-core";
      gpg.format = "ssh";
      credential.credentialStore = "gpg";
      core.autocrlf = "input";
      filter.lfs = {
        clean = "git-lfs clean -- %f";
      };
    };
  };

  home.shellAliases =
    {
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
      "nvdir" = "cd ~/.config/NixOS-Config/homemanager/pkgs/neovim";
      "dust" = "dust --reverse --ignore-directory mnt";
      "rebuild" = "home-manager switch --impure --show-trace --flake ~/.config/NixOS-Config/homemanager |& nom";
    };

  home.preferXdgDirectories = true;
  targets.genericLinux.enable = true; 
  nixpkgs.config = pkgs-config;
  nix.package = pkgs.lix;
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    use-xdg-base-directories = true; # throws warning but is needed for correct location of hm-session-variables.sh
  };

  home.username = user;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
