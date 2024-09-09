{ inputs, config, pkgs, lib, ... }:
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
  ];

  # Flatpaks
  services.flatpak.enable = true;
  services.flatpak.uninstallUnmanaged = true;
  services.flatpak.packages = [
    "com.spotify.Client"
    "com.mastermindzh.tidal-hifi"
    "com.discordapp.Discord"
    "com.valvesoftware.Steam"
    "page.kramo.Cartridges"
    "eu.betterbird.Betterbird"
    "org.libreoffice.LibreOffice"
    "com.github.hugolabe.Wike"
    "com.github.tchx84.Flatseal"
    "io.podman_desktop.PodmanDesktop"
  ];

  # Packages
  home.packages = (with pkgs; [
    # Flatpak
    flatpak

    # Customization
    papirus-icon-theme

    # Development
    jetbrains-toolbox
    blackbox-terminal
    ungoogled-chromium
    git
    nodejs
    dart-sass
    git-credential-manager

    # Utilities
    geekbench

    # Work
    slack

    # Gaming
    bottles
    wine
    winetricks
    protontricks
  ]);
}
