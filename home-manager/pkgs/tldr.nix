{pkgs,...}:
{
	home.packages = [pkgs.tealdeer];
	  xdg.configFile."tealdeer/config.toml".text = ''
    [display]
    use_pager = true
    compact = true

    [updates]
    auto_update = true
  '';

}