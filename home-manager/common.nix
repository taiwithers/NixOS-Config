{
  config,
  pkgs,
  lib,
  user,
  pkgs-config,
  config-name,
  ...
}:
{
  options.common = with lib; {
    nixConfigDirectory = mkOption {
      default = ../.;
      type = types.path;
      description = "location of nix config";
    };

    useXDG = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Tell Nix and Home Manager to use XDG directories. 
                              Requires manually adding 'use-xdg-base-directories = true' to /etc/nix/nix.conf'';
    };

    nixos = mkOption {
      default = true;
      type = types.bool;
    };

    # Reference options
    userHome = mkOption { default = "/home/${user}"; };
    configHome = mkOption { default = config.xdg.configHome; };
    stateHome = mkOption { default = config.xdg.stateHome; };
    dataHome = mkOption { default = config.xdg.dataHome; };
    cacheHome = mkOption { default = config.xdg.cacheHome; };
    hm-session-vars = mkOption { default = ""; };
  };

  config = {
    # Option-controlled configs
    home.preferXdgDirectories = config.common.useXDG;
    nix.settings.use-xdg-base-directories = config.common.useXDG; # throws warning but is needed for correct location of hm-session-variables.sh
    common.hm-session-vars =
      if config.common.useXDG then
        "~/.local/state/nix/profile/etc/profile.d/hm-session-vars.sh"
      else
        "/etc/profiles/per-user/${user}/etc/profile.d/hm-session-vars.sh";

    targets.genericLinux.enable = !config.common.nixos;

    # Static configs
    home.sessionVariables = with config.common; {
      XDG_CONFIG_HOME = configHome;
      XDG_STATE_HOME = stateHome;
      XDG_DATA_HOME = dataHome;
      XDG_CACHE_HOME = cacheHome;

      LESS = "--quit-if-one-screen --line-numbers --squeeze-blank-lines --use-color --RAW-CONTROL-CHARS";

      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configHome}/java";
      CUDA_CACHE_PATH = "${cacheHome}/nv";
      ERRFILE = "${cacheHome}/x11/xsession-errors";
      GNUPGHOME = "${dataHome}/GNUPG";
      ICEAUTHORITY = "${cacheHome}/ICEauthority";
      KERAS_HOME = "${stateHome}/keras";
      LESSHISTFILE = "${stateHome}/less_history";
      PARALLEL_HOME = "${configHome}/parallel";
      PASSWORD_STORE_DIR = "${dataHome}/pass";
      SQLITE_HISTORY = "${cacheHome}/sqlite_history";
      TERMINFO = "${dataHome}/terminfo";
      TERMINFO_DIRS = "${dataHome}/terminfo:/usr/share/terminfo";
      TEXMFVAR = "${cacheHome}/texlive/texmf-var";
      USERXSESSIONRC = "${cacheHome}/x11/xsessionrc";

      __HM_SESS_VARS_SOURCED = ""; # "unset" this
    };

    home.packages =
      with pkgs;
      [
        # nix
        nixfmt
        clean
        get-package-path
        search
        nixshell

        # utilities
        fd
        rename
        sd
        trashy
        zip
      ]
      ++ pkgs.lib.optionals (!config.common.nixos) [
        busybox
        coreutils
        xdg-utils
        diffutils
        findutils
        curl
      ]
      ++ pkgs.lib.optionals config.common.nixos [
        nixos-generations
      ];

    home.shellAliases =
      with config.common;
      {
        "untar" = "tar -xvf";
        "printenv" = "printenv | sort";
        "wget" = "wget --hsts-file=${stateHome}/wget_hsts";

        "confdir" = "cd ${nixConfigDirectory}";
        "nvdir" = "cd ${nixConfigDirectory}/home-manager/pkgs/neovim";
        "rebuild" = "rm ~/.config/gtk-2.0/gtkrc; home-manager switch --impure --show-trace --flake ${nixConfigDirectory}/home-manager#${config-name}";
        # "nomrebuild" = "rebuild |& nom";
        "pullconfig" = "(cd ${nixConfigDirectory} && git pull)";
        "formatconfig" = "(cd ${nixConfigDirectory} && nixfmt . )";
        "trash" = "trashy put";
      }
      // pkgs.lib.optionalAttrs (config.common.nixos) {
        "nixrebuild" =
          let
            nixconfig-name = pkgs.lib.lists.last (pkgs.lib.strings.splitString "-" config-name);
          in
          "sudo nixos-rebuild switch --impure --show-trace --flake ${nixConfigDirectory}/nixos#${nixconfig-name}";
      };

    xdg.configFile."${config.common.configHome}/vim/vimrc".text = ''
      if !has('nvim') " Neovim has its own location which already complies with XDG specification
        set viminfofile=$XDG_STATE_HOME/viminfo
      endif
    '';
    news.display = "silent"; # no output about hm news during switch
    nix.package = pkgs.lix;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nixpkgs.config = pkgs-config;
    home.username = user;
    home.homeDirectory = config.common.userHome;
    programs.home-manager.enable = true;
  };
}
