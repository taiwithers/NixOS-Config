{config, pkgs, ...}:{
	programs.tofi = {
		enable = true;
		settings = {
			font = "mono";
			font-size = 16;
			prompt-background-corner-radius = 1;
		};
	};

}