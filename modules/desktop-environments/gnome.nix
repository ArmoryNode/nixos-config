{ config, pkgs, lib, inputs, ... }: {

  # Enable GDM and GNOME
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Unlock keyring on login
  # security.pam.services.gdm-password.enableGnomeKeyring = true;

  # Install gnome packages
  users.users.armorynode.packages = (with pkgs; [
    gnome-extension-manager
    gnome-connections
    gnome-tweaks
    gnome-software
    smile
  ]) ++ (with pkgs.gnomeExtensions; [
    blur-my-shell
    just-perfection
    reboottouefi
    appindicator
    clipboard-history
    smile-complementary-extension
    tiling-shell
    simple-taskbar
  ]);

  # Exclude gnome packages
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
    evince
  ];

  # Add udev packages
  services.udev.packages = with pkgs; [
      gnome-settings-daemon
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
              appindicator.extensionUuid
              reboottouefi.extensionUuid
              just-perfection.extensionUuid
              clipboard-history.extensionUuid
              smile-complementary-extension.extensionUuid
              tiling-shell.extensionUuid
              simple-taskbar.extensionUuid
            ];

            favorite-apps = [
              "org.gnome.Nautilus.desktop" "firefox.desktop" "com.raggesilver.BlackBox.desktop" "code.desktop"
            ];
          };

          "org/gnome/shell/weather" = {
            automatic-location = true;
            locations = lib.gvariant.mkEmptyArray (lib.gvariant.type.string);
          };

          "org/gnome/shell/extensions/just-perfection" = {
            animation = lib.gvariant.mkInt32 1;
            weather = false;
          };

          "org/gnome/shell/keybindings" = {
            toggle-message-tray = [ "<Shift><Super>v" ];
          };

          "org/gnome/shell/extensions/simple-taskbar" = {
            dock-mode = true;
            hot-edge-overview-enabled = false;
            taskbar-highlight-style = "classic";
            animate-appicon-hover-animation-type = "magnify";
            animate-appicon-hover-animation-zoom = lib.gvariant.mkArray [
              (lib.gvariant.mkDictionaryEntry "simple" (lib.gvariant.mkDouble 1.0))
              (lib.gvariant.mkDictionaryEntry "ripple" (lib.gvariant.mkDouble 1.25))
              (lib.gvariant.mkDictionaryEntry "magnify" (lib.gvariant.mkDouble 1.5))
            ];
          };

          "org/gnome/shell/extensions/clipboard-history" = {
            toggle-menu = [ "<Super>v" ];
          };

          "org/gnome/shell/extensions/tilingshell" = {
            layouts-json = builtins.readFile ./extension-config/tiling-shell/layouts.json;
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
            icon-theme = "Conflux";
          };
        };
      }
    ];
  };
}
