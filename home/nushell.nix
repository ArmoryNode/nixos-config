{ config, pkgs, lib, ... }:
let
  ohMyPoshConfigPath = "./oh-my-posh/";
in 
{
  # Configure nushell
  programs.nushell = {
    enable = true;
    configFile.source = ./nushell/config.nu;
    envFile.source = ./nushell/env.nu;
  };

  # Addons and plugins
  programs = {
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };

    yazi = {
      enable = true;
      enableNushellIntegration = true;
    };

    thefuck = {
      enable = true;
      enableNushellIntegration = true;
    };

    oh-my-posh = {
      enable = true;
      enableNushellIntegration = true;
      settings = builtins.fromJSON (
        builtins.unsafeDiscardStringContext (
          builtins.readFile ./${ohMyPoshConfigPath}/custom.omp.json
        )
      );
    };
  };
}