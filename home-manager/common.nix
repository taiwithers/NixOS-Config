{
  config,
  pkgs,
  config-name,
  ...
}:
{
  options.common = with pkgs.lib; {
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
        Requires manually adding 'use-xdg-base-directories = true' to /etc/nix/nix.conf on non-NixOS'';
    };

    nixos = mkOption {
      default = true;
      type = types.bool;
    };

    wsl = mkOption {
        default = false;
        type = types.bool;
      };

    # Reference options
    userHome = mkOption { default = "/home/${config.home.username}"; };
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
        "/etc/profiles/per-user/${config.home.username}/etc/profile.d/hm-session-vars.sh";

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
      FIGNORE = ".lock"; # don't include .lock files in filename completion

      __HM_SESS_VARS_SOURCED = ""; # "unset" this
    };

    programs.fd.enable = true;
    programs.ripgrep.enable = true;

    home.packages =
      with pkgs;
      [
        # nix
        nixfmt
        clean
        get-package-path
        search
        nixshell
        nvd
        diff-nix-generations
        nix-tree

        # utilities
        rename
        sd
        zip
        trash-cli
        whichl

        # fonts
        cm_unicode
        open-sans
        dejavu_fonts
        nerd-fonts.space-mono
        nerd-fonts.symbols-only
        nerd-fonts.intone-mono
        
      ]
      ++ pkgs.lib.optionals (!config.common.nixos) [
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
        "rm" = "rm --interactive=always --verbose";
        "untar" = "tar -xvf";
        "printenv" = "printenv | sort";
        "wget" = "wget --hsts-file=${stateHome}/wget_hsts";

        "confdir" = "cd ${nixConfigDirectory}";
        "nvdir" = "cd ${nixConfigDirectory}/home-manager/pkgs/neovim";
        "rebuild" =
          "home-manager switch --impure --show-trace --flake ${nixConfigDirectory}#${config-name} -b backup && diff-hm-generations ";
        # "nomrebuild" = "rebuild |& nom";
        "pullconfig" = "(cd ${nixConfigDirectory} && git pull)";
        "formatconfig" = "(cd ${nixConfigDirectory} && nix fmt)";
        "diff-hm-generations" = "diff-nix-generations home";
      }
      // pkgs.lib.optionalAttrs config.common.nixos {
        "nixrebuild" =
          let
            nixconfig-name = pkgs.lib.lists.last (pkgs.lib.strings.splitString "-" config-name);
          in
          "nixos-rebuild switch --show-trace --use-remote-sudo --flake ${nixConfigDirectory}#${nixconfig-name} && diff-nixos-generations ";
        "diff-nixos-generations" = "diff-nix-generations nixos";
      };

    programs.bash.bashrcExtra = ''
      # add completions
      complete -F _command get-package-path
      complete -F _command whichl
    '';

    xdg.configFile."${config.common.configHome}/vim/vimrc".text = ''
      if !has('nvim') " Neovim has its own location which already complies with XDG specification
        set viminfofile=$XDG_STATE_HOME/viminfo
      endif
    '';

    home.file = {
      "clean_bash.sh" = {
        text = ''
          #!/usr/bin/env bash

          kitty -- bash --norc
        '';
        executable = true;
      };
    } // pkgs.lib.optionalAttrs (!config.common.nixos) {
      ".hushlogin".text = "";
    };

    programs.man = {
      enable = true; # default true
      generateCaches = true; # slightly slows rebuild, but allows things like apropos to work
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        global.hide_env_diff = true; # don't show big blob of environment variable changes
      };
    };

    news.display = "silent"; # no output about hm news during switch
    nix.package = pkgs.lix;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    # nix.settings.trusted-users = [ "@wheel"]; # no effect i think, needs to be done in /etc/nix/nix.conf

    home.homeDirectory = config.common.userHome;
    programs.home-manager.enable = true;
  };
}
