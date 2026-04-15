{ inputs, pkgs, ... }: let
	zen-browser = inputs.zen-browser.packages.${pkgs.system}.default;
in {
	home.packages = [
		zen-browser
	];
}