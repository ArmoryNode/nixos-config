{ config, pkgs, lib, inputs, ... }:
let
  hardwareConfig = ../../hardware-configuration.nix;
  nvidiaStable = ../../modules/nvidia/stable.nix;
  bootloader = ../../modules/bootloaders/grub2.nix;
  desktopEnv = ../../modules/desktop-environments/gnome.nix;
  dotnet = ../../modules/development/dotnet.nix;
  podman = ../../modules/virtualization/podman.nix;
  vmware = ../../modules/virtualization/vmware.nix;
  _1password = ../../modules/security/1password.nix;
in
{
  imports = [
    hardwareConfig
    nvidiaStable
    bootloader
    desktopEnv
    dotnet
    podman
    vmware
    _1password
  ];

  # Networking
  networking.hostName = "ArmoryNix";
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.armorynode = {
    isNormalUser = true;
    description = "ArmoryNode";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # Add system packages  
  environment.systemPackages = with pkgs; [
    inputs.nix-software-center.packages.${system}.nix-software-center

    libgcc
    go
    python3 
    distrobox
    ffmpeg_7-full
    nurl
  ];

  # Configure home manager
  home-manager.users.armorynode = import ./home.nix;
}
