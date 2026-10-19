{ config, pkgs, ... }: {
    services.tailscale = {
        enable = true;
        extraDaemonFlags = ["--no-logs-no-support"]; # Disable logging and telemetry
        package = pkgs.tailscale;
        extraSetFlags = ["--operator=armorynode"];
    };

    systemd.services.tailscaled-set.wantedBy = [ "multi-user.target" ];

    environment.systemPackages = with pkgs; [
        tailscale-systray
    ];

    networking.firewall = {
        enable = true;
        trustedInterfaces = [ config.services.tailscale.interfaceName ];
        allowedUDPPorts = [ config.services.tailscale.port ];
        checkReversePath = "loose";
    };
}