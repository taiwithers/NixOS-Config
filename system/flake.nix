{
	description = "NixOS Configuration";
	
	# flake dependencies
	inputs = {
		nixpkgs.url = "nixpkgs/nixos-23.11"; # github:nixos/nixpkgs/nixos-23.11
		nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
	};
	outputs = { self, nixpkgs, nixpkgs-unstable }:

	let 
		system = "x86_64-linux";
		pkgs = import nixpkgs{
			inherit system;
			config = {};
		};

		# https://nixos.wiki/wiki/Flakes#Importing_packages_from_multiple_channels
		overlay-unstable = final: prev: {
			# unstable = nixpkgs-unstable.legacyPackages.${prev.system};
			unstable = import nixpkgs-unstable {
				inherit system;
				config = {};
			};
		};

	in {
		nixosConfigurations."<hostname>" = nixpkgs.lib.nixosSystem {
			inherit system;
			# specialArgs = { inherit system; };
			modules = [
				# makes unstable available in configuration.nix
				({config,pkgs,...}:{nixpkgs.overlays=[overlay-unstable];})
				./configuration.nix
			];
		};
	};
}