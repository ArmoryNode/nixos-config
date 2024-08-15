{ config, pkgs, lib, inputs, ... }:
{
    # Networking
    networking.hostName = "ArmoryNotebook";
    networking.networkmanager.enable = true;

    # Timezone
    time.timeZone = "America/Los_Angeles";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    # Setup locale settings
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Configure keymap in X11
    services.xserver = {
        xkb.layout = "us";
        xkb.variant = "";
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    users.users.armorynode = {
        isNormalUser = true;
        description = "ArmoryNode";
        extraGroups = [ "networkmanager" "wheel" "docker" ];
        packages = with pkgs; [
            firefox
            firefoxpwa
            _1password-gui
            _1password
            (firefox-wayland.override { nativeMessagingHosts = [ firefoxpwa ]; })
        ];
    };

    # Allow 1Password to be unlocked by system authentication
    programs._1password.enable = true;
    programs._1password-gui = {
        enable = true;
        polkitPolicyOwners = [ "armorynode" ];
    };

    # Allow 1Password browser extension to connect to desktop app
    environment.etc = {
        "1password/custom_allowed_browsers" = {
            text = ''
                firefox
            '';
            mode = "0755";
        };
    };

    # Configure Firefox
    programs.firefox = {
        enable = true;
        nativeMessagingHosts.packages = [
            pkgs.firefoxpwa
        ];
        policies = {
            DisablePocket = true;
        };
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Enable flatpak support
    services.flatpak.enable = true;

    # Add system packages  
    environment.systemPackages = with pkgs; [
        inputs.nix-software-center.packages.${system}.nix-software-center

        libgcc
        go
        python3 
        distrobox
        ffmpeg_7-full
        nurl

        # For Podman
        dive
        podman-tui
        podman-compose
    ];

    # Exclude gnome packages
    environment.gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-connections
        epiphany
        geary
        evince
    ];

    # Add udev packages
    services.udev.packages = with pkgs; [
        gnome.gnome-settings-daemon
    ];

    # Configure flatpaks
    services.flatpak.packages = [
        "com.belmoussaoui.Decoder"
        "com.discordapp.Discord"
        "com.spotify.Client"
        "page.kramo.Cartridges"
        "eu.betterbird.Betterbird"
        "org.libreoffice.LibreOffice"
        "com.valvesoftware.Steam"
        "com.github.tchx84.Flatseal"
        "com.github.hugolabe.Wike"
        "io.podman_desktop.PodmanDesktop"
        "com.mattjakeman.ExtensionManager"
    ];

    # Enable ZSH and set it as the default shell
    programs.zsh.enable = true;
    users.users.armorynode.shell = pkgs.zsh;

    # Enable podman support
    virtualisation.containers.enable = true;
    virtualisation = { 
            podman = {
            enable = true;
            dockerCompat = true;
            defaultNetwork.settings.dns_enabled = true;
        };
    };

    # Start the Fingerprint driver at boot
    systemd.services.fprintd = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "simple";
    };

    # Install the driver
    services.fprintd.enable = true;
    services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

    # Configure home manager
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.armorynode = import ./home.nix;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?
}