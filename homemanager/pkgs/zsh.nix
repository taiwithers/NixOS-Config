{config, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true; # true by default
    enableVteIntegration = true;
    dotDir = ".config/zsh";

    autocd = true;
    autosuggestion = {
      enable = true;
      # highlight = "";
    };

    # cdpath = []; # List of paths to autocomplete calls to cd
    defaultKeymap = "vicmd"; # emacs, vicmd, viins
    dirHashes = {
      Student = "$HOME/OneDrive_Student";
      NixConfig = "$XDG_CONFIG_HOME/NixOS-Config";
    };

    # envExtra = "";
    
    # zshrc
    initExtra = ''
      bindkey "\t" autosuggest-accept
      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line
      bindkey "^[[F" vi-end-of-line

    '';
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
