{
  config,
  pkgs,
  lib,
  # inputs,
  user,
  nix-colors,
  # sops-nix,
  # system,
  # nix-flatpak,
  pkgs-config,
  ...
}: let
  theme-config = rec {
    # nix-colors-module = import nix-colors.homeManagerModules.default;
    colour-palette = nix-colors.colorSchemes."${builtins.head names}".palette;
    names = [
      "da-one-ocean" # dark vibrant
      "jabuti" # not available in nix-colors
      "horizon-terminal-dark" # vibrant, good!
      "framer"
      "ayu-dark"
      "hardcore"
      "porple" # washed out, grey-blue background
      "qualia" # black + vibrant pastels
      "rose-pine" # purple
      "zenbones" # orange/green/blue on black
    ];

    app-themes = builtins.mapAttrs (appName: appTheme: nix-colors.colorSchemes."${appTheme}".palette) {
      tilix = "da-one-ocean"; # change this once nix-colors supports base 24
      starship = "da-one-ocean"; # change this once nix-colors supports base 24
    };

    # function: select available theme
    selectAvailableTheme = functionGetThemePath: let
      checkTheme = name: builtins.pathExists (functionGetThemePath name);
      firstAvailableTheme =
        import ../nix-scripts/choose-option-or-backup.nix
        {
          functionOptionIsValid = checkTheme;
          allOptions = names;
        };
    in
      firstAvailableTheme;
  };

  homeDirectory = "/home/${user}";
in {
  imports = [
    # nix-flatpak.homeManagerModules.nix-flatpak
    (import ./packages.nix {inherit pkgs pkgs-config lib;})
    (import ./desktop-environment {inherit config pkgs;})
    (import ./package-configuration {inherit config pkgs lib theme-config;})
  ];

  gtk = rec {
    enable = true; # enable gtk 2/3 config
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    iconTheme = theme;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  sops = {
    defaultSopsFile = "${config.xdg.configHome}/sops/secrets/example-secrets.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    validateSopsFiles = false; # do not require sops files to be in the nix store

    secrets = {
      example_key = {
        path = "%r/example-key.txt";
      };
    };
  };

  home.activation.custom-sops-nix = let 
    systemctl = config.systemd.user.systemctlPath; 
    in "${systemctl} --user reload-or-restart sops-nix";
  home.file."testoutput".text = "${config.sops.secrets.example_key.key}";
  # mkdir --parents ~/.config/sops/age
  # age-keygen --output ~/.config/sops/age/keys.txt
  # to get public key:
  # age-keygen -y ~/.config/sops/age/keys.txt
  # mkdir ~/.config/sops/secrets
  # sops ~/.config/sops/secrets/example-secrets.yaml
  # vim ~/.config/sops/secrets/example-secrets.yaml

  home.username = user;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
