{ config, pkgs, inputs, ... }:
{
  services.xserver = {
  enable = true;
  displayManager.gdm.enable = true;
  desktopManager.gnome.enable = true;
  };

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
