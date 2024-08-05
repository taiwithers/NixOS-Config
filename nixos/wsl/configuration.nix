{ config, lib, pkgs, ... }:{

  imports = [
    ./hardware.nix
  ];

  wsl = rec {
  	enable = true;
  	defaultUser = "tai-wsl";
  	interop.includePath = false; # don't keep the windows path
  	startMenuLaunchers = false; # don't	add gui apps to windows start menu
  	wslConf.interop.enabled = false; # don't support running windows binaries
  	wslConf.interop.appendWindowsPath = interop.includePath; # don't keep the windows path
  	wslConf.user.default = defaultUser;
  };

  environment.systemPackages = with pkgs; [
  	git
  	vim
  ];
  programs.vim.defaultEditor = true;

  nix.settings = {
  	experimental-features = ["nix-command" "flakes"];
  	use-xdg-base-directories = true;
  };

  system.stateVersion = "24.05";
}