{ config, pkgs, lib, ... }: {
  # Enable Wireguard
  networking.wireguard.enable = true;
  networking.firewall.checkReversePath = "loose";

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}