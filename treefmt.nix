_: {
  projectRootFile = "flake.nix"; # how to find root

  settings.global.excludes = [
    "home-manager/pkgs/plasma/Compact.Menu/*"
    "scripts/unused/*"
  ];

  programs = {
    # generic
    dos2unix.enable = true;

    # nix
    deadnix.enable = true;
    nixfmt.enable = true;
    statix = {
      enable = true;
      disabled-lints = [ "repeated_keys" ];
    };

    # shell
    shfmt.enable = true;
    shellcheck.enable = true;

    # other
    formatjson5 = {
      enable = true;
      oneElementLines = true;
    };
    stylua.enable = true;
  };
}
