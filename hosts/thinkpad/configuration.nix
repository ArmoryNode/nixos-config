{ config, pkgs, lib, inputs, ... }:
let
  hardwareConfig = ../../hardware-configuration.nix;
  bootloader = ../../modules/bootloaders/grub2.nix;
  desktopEnv = ../../modules/desktop-environments/gnome.nix;
  podman = ../../modules/virtualization/podman.nix;
  vmware = ../../modules/virtualization/vmware.nix;
  _1password = ../../modules/security/1password.nix;
in
{
  imports = [
    hardwareConfig
    bootloader
    desktopEnv
    podman
    vmware
    _1password
  ];

  # Networking
  networking.hostName = "ArmoryThinkPad";
  networking.networkmanager.enable = true;

  # Configure firewall
  networking.firewall = {
    allowedUDPPorts = [ 1337 ];
  };

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
