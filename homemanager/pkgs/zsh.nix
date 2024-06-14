{config, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true; # true by default
    enableVteIntegration = true;
    dotDir = "${config.xdg.configHome}/zsh";

    autocd = true;
    autosuggestion = {
      enable = true;
      # highlight = "";
    };

    # cdpath = []; # List of paths to autocomplete calls to cd
    # defaultKeymap = ""; # emacs, vicmd, viins
    dirHashes = {
      Student = "$HOME/OneDrive_Student";
      NixConfig = "$XDG_CONFIG_HOME/NixOS-Config";
    };

    # envExtra = "";
    # initExtra = "";
    # initExtraBeforeCompInit = "";
    # initExtraFirst = "";
    # loginExtra = "";
    # logoutExtra = "";
    # profileExtra = "";

    history = {
      extended = true;
      ignoreDups = false;
      path = "${config.xdg.stateHome}/.zsh_history";
    };

    # plugins = {};

    # shellAliases = {};

    # syntaxHighlighting = {
    # 	enable = true;
    # 	highlighters = ["brackets"];
    # };
  };
}
