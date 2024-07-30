{
  config,
  pkgs,
  flake-inputs,
  user,
  pkgs-config,
  app-themes,
  ...
}:
{
  imports = map (fname: import ./pkgs/${fname}.nix { inherit config pkgs app-themes; }) [
    "bash"
    "bat"
    "bottom"
    "cod"
    "common-git"
    "duf"
    "dust"
    "eza"
    "fzf"
    "lazygit"
    "python/python"
    "starship"
    "superfile"
    "zoxide"
  ];
  home.packages = with pkgs; [
    fastfetch
    fd
    latex
    nix-output-monitor
    nixfmt
    ripgrep
    trashy
    xdg-ninja
  ] ++  builtins.attrValues (
    builtins.mapAttrs
      (name: fname: pkgs.writeShellScriptBin name (builtins.readFile ../scripts/${fname}.sh))
      {
        get-package-dir = "get-package-dir";
        gmv = "git-mv";
        clean = "clean";
      }
  );

  programs.git = {
    extraConfig = {
      credential.credentialStore = "gpg";
    };
  };

  home.shellAliases = {
    "rebuild" = "home-manager switch --impure --show-trace --flake ~/.config/NixOS-Config/homemanager |& nom";
  };
  nix.package = pkgs.lix;
  home.stateVersion = "24.05";
}
