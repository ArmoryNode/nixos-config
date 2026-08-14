{ pkgs, config, ... }: {
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [
      pkgs.firefoxpwa
    ];
    policies = {
      DisablePocket = true;
    };
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };
}