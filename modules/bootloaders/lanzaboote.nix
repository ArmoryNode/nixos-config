{ lib, pkgs, inputs, ... }: {
  environment.systemPackages = [
    pkgs.sbctl
  ];

  # Force disable systemd-boot
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}