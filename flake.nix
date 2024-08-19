{
	description = "NixOS Configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixos-wsl.url = "github:nix-community/nixos-wsl";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    lib = nixpkgs.lib;

    mkSystem = pkgs: system: hostname:
        pkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./hosts/${hostname}/configuration.nix
            ./modules/nixos/common.nix
            ./modules/nixos/grub2.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = { inherit inputs; };
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
  in
  {
    nixosConfigurations = {
      thinkpad = mkSystem inputs.nixpkgs system "thinkpad";
      desktop = mkSystem inputs.nixpkgs system "desktop";
      wsl = mkSystem inputs.nixpkgs system "wsl";
    };
  };
}
