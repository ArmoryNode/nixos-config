{
	description = "WSL Flake";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-software-center.url = "github:snowfallorg/nix-software-center";

    # WSL-specific
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixos-wsl.url = "github:nix-community/nixos-wsl";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{ self, nixpkgs, home-manager, vscode-server, nixos-wsl, nix-flatpak, ... }: {
		nixosConfigurations = {
			desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
        };

        modules = [
          home-manager.nixosModules.home-manager
          nix-flatpak.nixosModules.nix-flatpak
          ./hosts/desktop/configuration.nix
          ./modules/nixos/common.nix
          ./modules/nixos/grub2.nix
          ./modules/nvidia/stable.nix
          ./modules/desktop-environments/gnome.nix
        ];
      };
      
      wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
        };

        modules = [
          home-manager.nixosModules.home-manager
          vscode-server.nixosModules.default
          ./hosts/wsl/configuration.nix
          ./modules/nixos/common.nix
        ];
      };
    };
  };
}
