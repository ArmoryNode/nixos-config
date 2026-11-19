{ lib, ... }: {
  # Only let wheel users talk to the Nix daemon
  nix.settings.allowed-users = [ "@wheel" ];

  # Wipe /tmp on every boot
  boot.tmp.cleanOnBoot = true;

  # Enable sudo-rs
  security.sudo-rs.enable = true;

  # Enable AppArmor
  security.apparmor.enable = true;

  # Use the D-Bus broker implementation
  services.dbus.implementation = "broker";

  # Log refused firewall connections
  networking.firewall.logRefusedConnections = true;
}