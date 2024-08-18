{
  config,
  lib,
  pkgs,
  hostname,
  flake-inputs,
  ...
}: {
  imports = [
    ./hardware.nix
    flake-inputs.nixos-wsl.nixosModules.default
    {
      system.stateVersion = "24.05";#config.system.stateVersion;
      wsl =  rec {
        enable = true;
        defaultUser = "tai-wsl";
        interop.includePath = false; # don't keep the windows path
        startMenuLaunchers = false; # don't add gui apps to windows start menu
        wslConf.interop.enabled = false; # don't support running windows binaries
        wslConf.interop.appendWindowsPath = interop.includePath; # don't keep the windows path
        wslConf.user.default = defaultUser;
      };
    }
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
  ];
  programs.vim.defaultEditor = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.use-xdg-base-directories = true;

  # keep system up to date
  system.autoUpgrade = {
    enable = true;
    flags = [
      "--update-input"  
      "nixpkgs"
      "--commit-lock-file"
    ];
  };

  # keep system clean :)
  nix.optimise = {
    automatic = true;
    dates = ["weekly"];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  
  nix.settings.auto-optimise-store = true;
  
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";
  
  system.stateVersion = "24.05";
}
