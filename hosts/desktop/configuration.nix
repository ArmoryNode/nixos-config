{ config, pkgs, lib, inputs, ... }:
{
	imports = [
		./hardware-configuration.nix
		../../modules/nvidia/stable.nix
	];

	# Networking
	networking.hostName = "ArmoryNix";
	networking.networkmanager.enable = true;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.armorynode = {
		isNormalUser = true;
		description = "ArmoryNode";
		extraGroups = [ "networkmanager" "wheel" "docker" ];
		packages = with pkgs; [
			firefox
			firefoxpwa
			_1password-gui
			_1password
			(firefox-wayland.override { nativeMessagingHosts = [ firefoxpwa ]; })
		];
	};

	# Allow 1Password to be unlocked by system authentication
	programs._1password.enable = true;
	programs._1password-gui = {
		enable = true;
		polkitPolicyOwners = [ "armorynode" ];
	};

	# Allow 1Password browser extension to connect to desktop app
	environment.etc = {
		"1password/custom_allowed_browsers" = {
			text = ''
				firefox
			'';
			mode = "0755";
		};
	};
	
	# Configure Firefox
	programs.firefox = {
		enable = true;
		nativeMessagingHosts.packages = [
			pkgs.firefoxpwa
		];
		policies = {
			DisablePocket = true;
		};
	};

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# Add system packages  
	environment.systemPackages = with pkgs; [
		inputs.nix-software-center.packages.${system}.nix-software-center

		libgcc
		go
		python3 
		distrobox
		ffmpeg_7-full
		nurl

		# For Podman
		dive
		podman-tui
		podman-compose
	];

	# Enable ZSH and set it as the default shell
	programs.zsh.enable = true;
	users.users.armorynode.shell = pkgs.zsh;

	# Enable podman support
	virtualisation.containers.enable = true;
	virtualisation = { 
		podman = {
			enable = true;
			dockerCompat = true;
			defaultNetwork.settings.dns_enabled = true;
		};
	};

	# Configure home manager
	home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
	home-manager.users.armorynode = import ./home.nix;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.11"; # Did you read the comment?
}
