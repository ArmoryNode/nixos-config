{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Install gnome packages
  users.users.armorynode.packages = with pkgs; [
    gnome-connections
  ];

  # Install gnome-specific flatpaks
  services.flatpak.uninstallUnmanaged = true;
  services.flatpak.packages = [
    "com.mattjakeman.ExtensionManager"
  ];

  # Exclude gnome packages
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-connections
    epiphany
    geary
    evince
  ];

  # Add udev packages
  services.udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
  ];
}
