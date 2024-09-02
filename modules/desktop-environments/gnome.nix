{ config, pkgs, lib, inputs, ... }:
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

  # Unlock keyring on login
  # security.pam.services.gdm-password.enableGnomeKeyring = true;

  # Install gnome packages
  users.users.armorynode.packages = (with pkgs; [
    gnome-connections
    gnome-tweaks
    gnome-software
    smile
  ]) ++ (with pkgs.gnomeExtensions; [
    blur-my-shell
    just-perfection
    reboottouefi
    dash-to-dock
    appindicator
    wireguard-vpn-extension
    clipboard-history
    smile-complementary-extension
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
              smile-complementary-extension.extensionUuid
            ];

            favorite-apps = [
              "org.gnome.Nautilus.desktop" "firefox.desktop" "com.raggesilver.BlackBox.desktop" "code.desktop" "rider.desktop"
            ];
          };

          "org/gnome/shell/weather" = {
            automatic-location = true;
            locations = lib.gvariant.mkEmptyArray (lib.gvariant.type.string);
          };

          "org/gnome/shell/keybindings" = {
            toggle-message-tray = [ "<Shift><Super>v" ];
          };

          "org/gnome/shell/extensions/dash-to-dock" = {
            apply-custom-theme = true;
            show-mounts = false;
            show-show-apps-button = false;
            show-trash = false;
          };

          "org/gnome/shell/extensions/clipboard-history" = {
            toggle-menu = [ "<Super>v" ];
          };

          "org/gnome/mutter" = {
            center-new-windows = true;
          };
            
          "org/gnome/desktop/interface" = {
            clock-format = "12h";
            color-scheme = "prefer-dark";
            enable-animations = true;
            enable-hot-corners = false;
            gtk-enable-primary-paste = false;
            icon-theme = "Papirus-Dark";
          };
        };
      }
    ];
  };
}
