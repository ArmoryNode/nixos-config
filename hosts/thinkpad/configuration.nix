{ config, pkgs, lib, inputs, ... }:
let
  hardwareConfig = ../../hardware-configuration.nix;
  bootloader = ../../modules/bootloaders/grub2.nix;
  desktopEnv = ../../modules/desktop-environments/gnome.nix;
  podman = ../../modules/virtualization/podman.nix;
  wireguard = ../../modules/networking/wireguard.nix;
  _1password = ../../modules/security/1password.nix;
in
{
  imports = [
    hardwareConfig
    bootloader
    desktopEnv
    podman
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

  # Configure swap space - using dedicated partition for hibernation
  swapDevices = [{
    device = "/dev/disk/by-uuid/05e05e4e-77dc-4994-854e-a3ee6a53c7e5";
  }];

  # Hibernation configuration
  boot.resumeDevice = "/dev/disk/by-uuid/05e05e4e-77dc-4994-854e-a3ee6a53c7e5";
  boot.kernelParams = [
    "resume=UUID=05e05e4e-77dc-4994-854e-a3ee6a53c7e5"
  ];
  
  # Fix for hibernate
  security.protectKernelImage = false;

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

  # Configure dynamic linking
  programs.nix-ld.enable = true;

  # Enable power management
  powerManagement.enable = true;
  
  # Enable hibernation support
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=180
    SuspendState=mem
    HibernateState=disk
    HybridSleepState=disk
    HybridSleepMode=suspend platform shutdown
  '';
  
  # Ensure systemd hibernation service is available
  systemd.targets.hibernate.enable = true;

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

  # Temporary workaround for dotnet
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-core-combined"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
    "dotnet-sdk-7.0.410"
  ];

  # Configure home manager
  home-manager.users.armorynode = import ./home.nix;
}
