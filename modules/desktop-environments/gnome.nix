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
  ]) ++ (with pkgs.gnomeExtensions; [
    blur-my-shell
    just-perfection
    reboottouefi
    appindicator
    clipboard-history
    tiling-shell
    simple-taskbar
    emoji-copy
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
              emoji-copy.extensionUuid
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
