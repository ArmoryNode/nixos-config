{ config, pkgs, lib, inputs, ... }: {
  imports = [
    ../../modules/nixos/common.nix
    inputs.nixos-wsl.nixosModules.wsl
    inputs.vscode-server.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = "wsl";
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
    package = pkgs.nix-ld;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.wsl = {
    isNormalUser = true;
    description = "WSL";
    shell = pkgs.nushell; # Make sure to import the NuShell module in ./home.nix
    packages = with pkgs; [
      csharprepl
      git-credential-manager
      dart-sass
      git
      nodejs
      wget
    ];
    extraGroups = [ "wheel" ];
  };

  # Configure home manager
  home-manager.users.wsl = import ./home.nix;
}
