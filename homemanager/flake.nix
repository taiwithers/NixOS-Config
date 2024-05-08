{
	description = "Home Manager Configuration";

	# dependencies
	inputs = {
		nixpkgs.url = "nixpkgs/nixos-23.11";
		nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-colors.url = "github:misterio77/nix-colors";
	};

	# outputs = { nixpkgs, nixpkgs-unstable, home-manager }@inputs:
	outputs = { nixpkgs, nixpkgs-unstable, home-manager, nix-colors }:
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

		homeConfigurations."<hostname>" = home-manager.lib.HomeManagerConfiguration {
			inherit pkgs;
			specialArgs = { inherit inputs; };
			modules = [
				./home.nix
				./modules
			];
		};
	};
}