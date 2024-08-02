{ config, pkgs, ... }:
{
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Put common configuration options here
}