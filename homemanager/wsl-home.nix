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
  wayland.windowManager.sway.checkConfig = false;
  home.packages =
    with pkgs;
    [
      swayfx
      rofi
      tilix
      qtile

      cbonsai
      dust # view specific info for directories
      fastfetch
      fd
      fzf
      gcc
      gnumake
      lavat
      nixfmt
      nix-output-monitor
      pond
      ripgrep
      ripgrep-all
      shellcheck
      starfetch
      superfile
      trashy
      xdg-ninja
      zellij
    ]
    ++ shell-scripts
    ++ [
      (pkgs.writeShellApplication {
        name = "search";
        runtimeInputs = [
          nix
          nix-search-cli
          jq
          sd
        ];
        excludeShellChecks = [
          "SC2046"
          "SC2155"
          "SC2086"
          "SC2116"
          "SC2005"
          "SC2162"
        ];
        text = builtins.readFile ../scripts/nix-search-wrapper.sh;
      })
    ];

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

  home.shellAliases = {
    # use new programs
    "grep" = "echo 'Consider using ripgrep [rg] or batgrep instead'";

    # simplify commands
    "untar" = "tar -xvf";
    "confdir" = "cd ~/.config/NixOS-Config";
    "nvdir" = "cd ~/.config/NixOS-Config/homemanager/pkgs/neovim";
    "dust" = "dust --reverse --ignore-directory mnt";
    "rebuild" = "home-manager switch --impure --show-trace --flake ~/.config/NixOS-Config/homemanager |& nom";
    "which" = "which -a | sort --unique";
    "printenv" = "printenv | sort";
  };

  home.sessionVariables = with config.xdg; {
    XDG_CONFIG_HOME="${configHome}";
    XDG_STATE_HOME="${stateHome}";
    XDG_DATA_HOME="${dataHome}";
    XDG_CACHE_HOME="${cacheHome}";

    GNUPGHOME="${dataHome}/GNUPG";
    ICEAUTHORITY="${cacheHome}/ICEauthority";
    TERMINFO="${dataHome}/terminfo";
    TERMINFO_DIRS="${dataHome}/terminfo:/usr/share/terminfo";
    PARALLEL_HOME="${configHome}/parallel";
    PASSWORD_STORE_DIR="${dataHome}/pass";
    KERAS_HOME="${stateHome}/keras";
    SQLITE_HISTORY="${cacheHome}/sqlite_history";
    ERRFILE="${cacheHome}/x11/xsession-errors";
    USERXSESSIONRC="${cacheHome}/x11/xsessionrc";
    _JAVA_OPTIONS="-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
  };

  programs.bash.initExtra = ''
    # https://superuser.com/a/1604662
    old_PATH=$PATH:; PATH=
    while [ -n "$old_PATH" ]; do
      x=''${old_PATH%%:*}       # the first remaining entry
      case $PATH: in
        *:"$x":*) ;;          # already there
        *) PATH=$PATH:$x;;    # not there yet
      esac
      old_PATH=''${old_PATH#*:}
    done
    PATH=''${PATH#:}
    unset old_PATH x
  '';

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
