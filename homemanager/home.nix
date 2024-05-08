{
  config,
  pkgs,
  inputs, # since we have @inputs in the flake
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./packages.nix
    ./gnome-settings.nix
    ./autostart.nix
    ./fonts.nix
    ./vscodium.nix
    ./tex.nix
  ];

  home.username = "tai";
  home.homeDirectory = "/home/tai";
  # home.preferXdgDirectories = true; # doesn't seem to work?

  colorScheme = inputs.nix-colors.colorSchemes.hardcore;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shellAliases
  home.shellAliases = {
    "grep" = "rg";
    "untar" = "tar -xvf";
    "ls" = "eza --long --colour=always --icons=always --hyperlink --all --group-directories-first --header --time-style iso --no-permissions --no-user --git";
    "tree" = "eza --tree --colour=always --icons=always --hyperlink --all --group-directories-first --header --time-style iso --no-permissions --no-user --git";
    "rebuild" = "bash ~/.config/nixfiles/rebuild.sh";
    "mamba" = "micromamba";
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.settings
  # nix.settings = {
  #   auto-optimise-store = true;
  #   experimental-features = "nix-command";
  # };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # or
  #  /etc/profiles/per-user/tai/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    EDITOR = "vim";
    XDG_DATA_HOME = "~/.local/share";
    XDG_STATE_HOME = "~/.local/state";
    XDG_CONFIG_HOME = "~/.config";
    XDG_CACHE_HOME = "~/.cache";
    IPYTHONDIR = "${config.home.sessionVariables.XDG_CONFIG_HOME}/ipython";
    JUPYTER_CONFIG_DIR = "${config.home.sessionVariables.XDG_CONFIG_HOME}/jupyter";
  };

  xdg.mimeApps.defaultApplications = {
    "text/plain" = ["sublime_text.desktop"];
    "application/pdf" = ["firefox.desktop"];
  };

  # colours are defined in .config/gtk-4.0
  # ln -s ~/.config/gtk-4.0/gtk.css  ~/.config/gtk-3.0/gtk.css 
  gtk = {
    enable = true;
    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3";
  };
  qt = {
    enable = true;
    platformTheme = "gtk"; # gtk or gnome
    style.name = "adwaita-dark"; # one of the default themes
    style.package = pkgs.adwaita-qt;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
