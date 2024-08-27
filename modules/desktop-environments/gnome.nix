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
    clipboard-history
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
        settings = {
          # Enable user extensions
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = with pkgs.gnomeExtensions; [
              blur-my-shell.extensionUuid
              dash-to-dock.extensionUuid
              appindicator.extensionUuid
              reboottouefi.extensionUuid
              just-perfection.extensionUuid
              wireguard-vpn-extension.extensionUuid
              clipboard-history.extensionUuid
            ];
          };

          # Center new windows
          "org/gnome/mutter" = {
            center-new-windows = true;
          };

          # Set favorite apps
          "org/gnome/shell" = {
            favorite-apps = [
              "org.gome.Nautilus.desktop"
              "firefox.desktop"
              "com.raggesilver.BlackBox.desktop"
            ];
          };

          # Dash to Dock settings
          "org/gnome/extensions/dash-to-dock" = {
            apply-custom-theme = true;
            show-mounts = false;
            show-show-apps-button = false;
            show-trash = false;
          };

          # Rebind notification tray to `Shift+Super+v`
          "org/gnome/shell/keybindings" = {
            toggle-message-tray = [ "<Shift><Super>v" ];
          };

          # Bind clipboard history to `Super+v` (similar to Windows clipboard)
          "org/gnome/shell/extensions/clipboard-history" = {
            toggle-menu=[ "<Super>v" ];
          };
        };
      }
    ];
  };
}
