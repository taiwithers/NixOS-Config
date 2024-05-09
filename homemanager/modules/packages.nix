{
  config,
  pkgs,
  lib,
  user,
  system,
  ...
}: {
  home.packages = [];
  # nixpkgs.config = {
  #   allowUnfreePredicate = pkg:
  #     builtins.elem (lib.getName pkg) [
  #       "dell-command-configure"
  #       "discord"
  #       "obsidian"
  #       "realvnc-vnc-viewer"
  #       "slack"
  #       "sublimetext4"
  #       "zoom"
  #     ];
  #   permittedInsecurePackages = [
  #     "electron-25.9.0"
  #     "openssl-1.1.1w"
  #   ];
  # };

  # home.packages = with pkgs; [
  #   # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

  #   # # You can also create simple shell scripts directly inside your
  #   # # configuration. For example, this adds a command 'my-hello'
  #   # (pkgs.writeShellScriptBin "my-hello" ''
  #   #   echo "Hello, ${config.home.username}!"
  #   # '')

  #   alejandra
  #   nix-prefetch-scripts
  #   nurl # appimage-run

  #   bash
  #   bat
  #   btop
  #   curl
  #   dconf
  #   eza
  #   fd
  #   fzf
  #   git
  #   jq
  #   lazygit
  #   rename
  #   ripgrep
  #   speedtest-rs
  #   trashy
  #   unzip
  #   wget
  #   xdg-ninja
  #   zip
  #   zsh
  #   oh-my-zsh
  #   gfortran
  #   openssh
  #   pandoc
  #   parallel
  #   pomodoro
  #   python3

  #   dell-command-configure
  #   discord
  #   filezilla
  #   github-desktop
  #   gparted
  #   keepassxc
  #   libsForQt5.dolphin
  #   obsidian
  #   onedrive
  #   onedrivegui
  #   realvnc-vnc-viewer
  #   teams-for-linux
  #   tilix
  #   zoom-us
  #   gnome.gnome-tweaks
  #   libreoffice
  #   slack-dark
  #   gnome.gnome-screenshot

  #   unstable-pkgs.copyq
  #   unstable-pkgs.fastfetch
  #   unstable-pkgs.sublime4
  #   unstable-pkgs.zotero_7
  # ];
  # programs.git = {
  #   enable = true;
  #   signing.key = "/home/${user}/.ssh/id_ed25519_github.pub";
  #   signing.signByDefault = true;
  #   userEmail = "59430904+taiwithers@users.noreply.github.com";
  #   userName = "taiwithers";
  #   extraConfig = {
  #     gpg.format = "ssh";
  #     pull.rebase = "false";
  #     init.defaultBranch = "main";
  #   };
  #   delta = {
  #     enable = true;
  #     options = {
  #       dark = true;
  #       side-by-side = true;
  #     };
  #   };
  # };

  # services.copyq = {
  #   enable = true;
  #   package = unstable-pkgs.copyq;
  #   };
}
