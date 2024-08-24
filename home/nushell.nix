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

  # Configure carapace
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  # Configure zoxide
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  # Configure oh-my-posh
  programs.oh-my-posh = {
    enable = true;
    enableNushellIntegration = true;
    settings = builtins.fromJSON (
      builtins.unsafeDiscardStringContext (
        builtins.readFile ./${ohMyPoshConfigPath}/custom.omp.json
      )
    );
  };
}