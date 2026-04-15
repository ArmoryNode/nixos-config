{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixos-wsl.url = "github:nix-community/nixos-wsl";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: let
    # Auto discover hosts
    hostNames = builtins.filter
      (name: builtins.pathExists (./hosts + "/${name}/default.nix"))
      (builtins.attrNames (builtins.readDir ./hosts));
  in {
    # Build NixOS configurations for each host
    nixosConfigurations = builtins.listToAttrs (map (hostname: {
        name = hostname;
        value = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
                ./hosts/${hostname}/default.nix
                home-manager.nixosModules.home-manager {
                    home-manager = {
                        useUserPackages = true;
                        useGlobalPkgs = true;
                        extraSpecialArgs = { inherit inputs; };
                    };
                }
            ];
        };
    }) hostNames);
  };
}
