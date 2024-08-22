{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  # Enable GDM and GNOME
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Install gnome packages
  users.users.armorynode.packages = (with pkgs; [
    gnome-connections
    gnome-tweaks
    gnome.gnome-software
  ]) ++ (with pkgs.gnomeExtensions; [
    blur-my-shell
    just-perfection
    reboottouefi
    dash-to-dock
    appindicator
    wireguard-vpn-extension
  ]);

  # Install gnome-specific flatpaks
  services.flatpak.uninstallUnmanaged = true;
  services.flatpak.packages = [
    "com.mattjakeman.ExtensionManager"
  ];

  # Exclude gnome packages
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
    evince
  ];

  # Add udev packages
  services.udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
  ];

  # Configure additional dconf settings
  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = with pkgs.gnomeExtensions; [
              blur-my-shell.extensionUuid
              dash-to-dock.extensionUuid
              appindicator.extensionUuid
              reboottouefi.extensionUuid
              just-perfection.extensionUuid
              wireguard-vpn-extension.extensionUuid
            ];
          };
        };
      }
    ];
  };
}
