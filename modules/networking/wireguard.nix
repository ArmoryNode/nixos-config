{ config, pkgs, lib, ... }:
{
  # Enable Wireguard
  networking.wireguard.enable = true;
  networking.firewall.checkReversePath = false;

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}