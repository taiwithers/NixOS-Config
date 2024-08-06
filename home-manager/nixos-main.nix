{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  app-themes,
  fonts,
  ...
}: {
  imports = [
    (import ./packages.nix {inherit config pkgs app-themes;})
    (import ./pkgs/xdg.nix {inherit pkgs;})

    # autostart
    (
      let
        autostart-pkgs = with pkgs; [
          teams-for-linux
          onedrivegui
        ];
      in
        import ../scripts/autostart.nix {inherit config autostart-pkgs;}
    )
  ];

  # gnome taskbar
  dconf.settings."org/gnome/shell".favorite-apps = with pkgs;
    map (pkg: (import ../scripts/locate-desktop.nix) pkg) [
      firefox
      dolphin
      sublime4
      tilix
      vscodium-fhs
      obsidian
    ];

  common.nixConfigDirectory = "${config.common.configHome}/NixOS-Config";
  common.useXDG = true;
  common.nixos = true;

  home.packages = fonts;
  home.stateVersion = "23.11";
}
