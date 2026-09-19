{ inputs, config, pkgs, lib, ... }: let
  colloid-gtk-custom = pkgs.colloid-gtk-theme.overrideAttrs {
    themeVariants = [ "grey" ];
    colorVariants = [ "dark" ];
    tweaks = [ "rimless" ];
  };
in
{
  # Configure home manager
  home.username = "armorynode";
  home.homeDirectory = "/home/armorynode";
  home.stateVersion = "23.11";

  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ../../home/common.nix
    ../../home/nushell.nix
    ../../home/git.nix
    ../../home/nerdfonts.nix
    ../../home/vscode.nix
    ../../home/firefox.nix
    ../../home/fastfetch.nix
    ../../home/btop.nix
    ../../home/bat.nix
    ../../home/dotnet.nix
    ../../home/elm.nix
    ../../home/webdev.nix
    ../../home/rider.nix
  ];

  # Flatpaks
  services.flatpak.enable = true;
  services.flatpak.uninstallUnmanaged = true;
  services.flatpak.update.onActivation = true;
  services.flatpak.packages = [
    { appId = "com.spotify.Client"; origin = "flathub"; }
    { appId = "com.mastermindzh.tidal-hifi"; origin = "flathub"; }
    { appId = "com.discordapp.Discord"; origin = "flathub"; }
    { appId = "com.valvesoftware.Steam"; origin = "flathub"; }
    { appId = "eu.betterbird.Betterbird"; origin = "flathub"; }
    { appId = "org.libreoffice.LibreOffice"; origin = "flathub"; }
    { appId = "com.github.hugolabe.Wike"; origin = "flathub"; }
    { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
    { appId = "io.podman_desktop.PodmanDesktop"; origin = "flathub"; }
  ];

  # Packages
  home.packages = (with pkgs; [
    # Customization
    papirus-icon-theme

    # Development
    blackbox-terminal
    ungoogled-chromium
    git
    git-credential-manager

    # Utilities
    geekbench
    nomachine-client

    # Work
    slack

    # Gaming
    bottles
    wine
    winetricks
    protontricks

    # GNOME theme
    colloid-gtk-custom

    # Productivity
    protonmail-desktop
    obsidian
    
    # Misc
    mediawriter
  ]);
}
