{ config, pkgs, lib, inputs, ... }: let
  hardwareConfig = ./hardware-configuration.nix;
  common = ../../modules/nixos/common.nix;
  desktopCommon = ../../modules/nixos/desktop.nix;
  nvidiaStable = ../../modules/nvidia/stable.nix;
  bootloader = ../../modules/bootloaders/lanzaboote.nix;
  desktopEnv = ../../modules/desktop-environments/gnome.nix;
  podman = ../../modules/virtualization/podman.nix;
  vmware = ../../modules/virtualization/vmware.nix;
  _1password = ../../modules/security/1password.nix;
in
{
  imports = lib.optional (builtins.pathExists hardwareConfig) hardwareConfig ++ [
    common
    desktopCommon
    nvidiaStable
    bootloader
    desktopEnv
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
    inputs.nix-software-center.packages.${pkgs.system}.nix-software-center

    libgcc
    go
    python3 
    distrobox
    ffmpeg_7-full
    nurl
  ];

  # Set up Nu shell
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "nu" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.nushell}/bin/nu $LOGIN_OPTION
      fi
    '';
  };

  # Configure home manager
  home-manager.users.armorynode = import ./home.nix;
}
