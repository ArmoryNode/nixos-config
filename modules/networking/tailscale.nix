{ config, pkgs, ... }: {
    services.tailscale.enable = true;
    services.tailscale.extraDaemonFlags = ["--no-logs-no-support"]; # Disable logging and telemetry

    networking.firewall = {
        checkReversePath = "loose";
        allowedUDPPorts = [ 41641 ];
    };

    environment.systemPackages = with pkgs; [
        tailscale
        tailscale-systray
    ];
}