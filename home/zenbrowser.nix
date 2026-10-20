{ inputs, pkgs, ... }: let
  zen = import (builtins.fetchTarball {
    url = "https://github.com/youwen5/zen-browser-flake/archive/458cd16116c362a5e92d5db6bdc3599e4e8b1f4a.tar.gz";
		sha256 = "1lsn1pxq6k0syk8q537apkz1x334gy7jrlfm275ywkrmx3k494ma";
  }) {
    inherit pkgs;
  };
in {
	home.packages = [
		# inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
		zen.default
	];
}