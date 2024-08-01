{
	description = "WSL Flake";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixos-wsl.url = "github:nix-community/nixos-wsl";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{ self, nixpkgs, home-manager, vscode-server, nixos-wsl, ... }: {
		nixosConfigurations = {
			wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };

        system = "x86_64-linux";
        modules = [
          ./hosts/wsl/configuration.nix
          ./modules/nixos/common.nix
          home-manager.nixosModules.home-manager
          vscode-server.nixosModules.default
        ];
      };
    };
  };
}
