{ config, pkgs, lib, inputs, ... }: let
  conflux-icon-theme = pkgs.callPackage ../../modules/custom/themes/conflux-icon-theme.nix {
    src = inputs.conflux-icon-theme;
  };
in {
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
    ../../home/rider.nix
    ../../home/ollama.nix
  ];

  # Configure home manager
  home.username = "armorynode";
  home.homeDirectory = "/home/armorynode";
  home.stateVersion = "23.11";

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
    conflux-icon-theme

    # Development
    blackbox-terminal
    ungoogled-chromium
    nodejs
    dart-sass
    csharprepl
    fsautocomplete
    git-credential-manager

    # Utilities
    zoxide
    fzf
    btop
    bat
    fastfetch
    geekbench
    sbctl

    # Work
    slack

    # Gaming
    bottles
    wine
    winetricks
    protontricks
  ]);

  # Configure zshell
  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "zoxide"
      ];
      theme = "agnoster";
    };
    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
  };


  # Configure dotfiles
  home.file = {};

  # Configure session variables
  home.sessionVariables = {};

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
