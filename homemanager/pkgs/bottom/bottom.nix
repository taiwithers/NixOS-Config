{config, ...}: {
  home.shellAliases = {"htop" = "echo 'Did you mean btm?'";};

  xdg.configFile."${config.xdg.configHome}/bottom/bottom.toml".source = ./bottom.toml;
}
