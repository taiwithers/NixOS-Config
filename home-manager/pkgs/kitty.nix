{config, pkgs, app-themes, ...}:{
	programs.kitty = {
		enable = true;
		shellIntegration.enableBashIntegration = true;

		font = {
			name = "Intel One Mono";
			size = 11;
		};

		settings = {
			copy_on_select = "clipboard";
			tab_bar_edge = "top";
			background_opacity = "0.9";
			background_blur = 1;

		};

		# base 16 theme
		extraConfig = let 
			kittyThemes = pkgs.fetchFromGitHub {
				owner = "tinted-theming";
				repo = "tinted-kitty";
				rev = "d1604e5";
				hash = "sha256-MbBorH5DCktd8Ph5b7s06mBI1yP6RqOIj/W5yYKFSno=";
			};
		in
		builtins.readFile "${kittyThemes}/colors/${app-themes.filenames.kitty}.conf";
	};
}