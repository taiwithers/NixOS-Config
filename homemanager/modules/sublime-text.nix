{ config, pkgs, ...}:
let 
	packagesPath = "${config.xdg.configHome}/sublime-text/Packages/User";
	packages = [
		{
			name = "Package Control";
			owner = "wbond";
			repo = "package_control";
			rev = "latest"; # 4.0.6 unlikely to work, will likely need to switch to either commit hash or release tag
			hash = "";  # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
		}
		{
			owner = "ThomasKliszowski";
			repo = "json_reindent";
			rev = "latest"; # 2.0.4
			hash = "";  # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
		}
		{
			owner = "titoBouzout";
			repo = "SideBarEnhancements";
			rev = "latest"; # 12.0.4
			hash = "";  # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
		}
		{
			owner = "SublimeText";
			repo = "AFileIcon";
			rev = "latest"; # 3.27.0
			hash = "";  # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
		}
		# {
		# 	owner = "kemayo";
		# 	repo = "sublime-text-git";
		# 	rev = "latest"; # f649fe4 / f649fe4ba657ce9c132cadb91f97c6f8d98834c2
		# 	hash = "";  # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
		# }
		{
			owner = "SublimeText";
			repo = "Origami";
			rev = "latest"; # 7369b11 / 7369b117290d72629cf2d226e90998b8ec22fb82
			hash = "";  # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
		}
		# {
		# 	owner = "";
		# 	repo = "";
		# 	rev = "latest";
		# 	hash = "";  # note this refers to the hash of the Nix derivation *output* not the file download, grab this from the error message
		# }

	];

in
{
	# either of these should work i'm pretty sure?
	# xdg.configFile = builtins.listToAttrs ( map (package: {
	# 		name = "${packagesPath}/${package.repo}";
	# 		value = { source = fetchFromGithub package; };
	# 		}) packages);
	xdg.configFile = map ( "${packagesPath}/${package.repo}".source: fetchFromGithub package ) packages;

	xdg.configFile."${packagesPath}/Preferences.sublime-settings".source = ./non-nix/Preferences.sublime-settings;
	xdg.configFile."${packagesPath}/Default.sublime-keymap".source = ./non-nix/Default.sublime-keymap;
}