{ config, pkgs, lib, inputs, ... }: let
  hardwareConfig = ./hardware-configuration.nix;
  common = ../../modules/nixos/common.nix;
  desktopCommon = ../../modules/nixos/desktop.nix;
  bootloader = ../../modules/bootloaders/grub2.nix;
  desktopEnv = ../../modules/desktop-environments/gnome.nix;
  podman = ../../modules/virtualization/podman.nix;
  tailscale = ../../modules/networking/tailscale.nix;
  wireguard = ../../modules/networking/wireguardd.nix;
  _1password = ../../modules/security/1password.nix;
in
{
  imports = lib.optional (builtins.pathExists hardwareConfig) hardwareConfig ++ [
    common
    desktopCommon
    bootloader
    desktopEnv
    podman
    tailscale
    wireguard
    _1password
  ];

  # Networking
  networking.hostName = "ArmoryThinkPad";
  networking.networkmanager.enable = true;

  # Configure firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

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

  # Enable Flatpak
  services.flatpak.enable = true;

  # Start the Fingerprint driver at boot
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };
  services.fprintd.enable = true;
  services.fprintd.tod = {
    enable = true;
    driver = pkgs.libfprint-2-tod1-goodix-550a;
  };

  # Configure direnv
  programs.direnv = {
    enable = true;
  };

  # Configure dynamic linking
  programs.nix-ld.enable = true;

  # Enable power management
  powerManagement.enable = true;

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
