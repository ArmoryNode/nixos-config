{ config, pkgs, lib, ... }:
{
  # Configure nushell
  programs.nushell = {
    enable = true;
    configFile.source = ./nushell/config.nu;
    envFile.source = ./nushell/env.nu;
  };

  # Enable carapace
  programs.carapace.enable = true;
  programs.carapace.enableNushellIntegration = true;

  # Enable zoxide
  programs.zoxide.enable = true;
  programs.zoxide.enableNushellIntegration = true;

  # Enable oh-my-posh
  programs.oh-my-posh.enable = true;
  programs.oh-my-posh.enableNushellIntegration = true;
}