{ config, lib, inputs, ... }:
let
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in
{
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
  ];

  # Networking
  networking.hostName = "ArmoryNIX";
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

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
    ffmpeg_5-full
    nurl

    # For Podman
    dive
    podman-tui
    podman-compose
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

  # Configure home manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.nixos = import ./home.nix;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}