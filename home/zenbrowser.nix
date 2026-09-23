{ inputs, pkgs, ... }: let
	zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
	home.packages = [
		zen-browser
	];
}