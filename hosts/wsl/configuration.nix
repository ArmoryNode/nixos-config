{ config, lib, inputs, ... }:
{
	imports = [
		inputs.nixos-wsl.nixosModules.wsl
		inputs.vscode-server.nixosModules.default
	];

	wsl = {
		enable = true;
		defaultUser = "nixos";
		extraBin = [
			{ src = lib.getExe' pkgs.coreutils "dirname"; }
			{ src = lib.getExe' pkgs.coreutils "readlink"; }
			{ src = lib.getExe' pkgs.coreutils "uname"; }
		];
	};

	# Enable the VSCode server
	services.vscode-server.enable = true;

	# Allow VSCode server to run
	programs.nix-ld = {
		enable = true;
		package = pkgs.nix-ld-rs;
	};

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.nixos = {
		isNormalUser = true;
		description = "WSL";
		packages = with pkgs; [
			(with dotnetCorePackages; combinePackages [
				sdk_6_0
				sdk_7_0
				sdk_8_0
			])
			csharprepl
			git-credential-manager
			dart-sass
			git
			nodejs
			wget
		];
	};

	# Enable ZSH and set it as the default shell
	programs.zsh.enable = true;
	users.users.nixos.shell = pkgs.zsh;

	# Configure home manager
	home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
	home-manager.users.nixos = import ./home.nix;
}
