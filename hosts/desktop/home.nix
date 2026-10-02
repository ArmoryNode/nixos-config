{ config, pkgs, lib, inputs, ... }: let
  conflux-icon-theme = pkgs.callPackage ../../modules/custom/themes/conflux-icon-theme.nix {
    src = inputs.conflux-icon-theme;
  };
in {
  imports = [
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
    ../../home/ollama.nix
    ../../home/zenbrowser.nix
    ../../home/webdev.nix
    ../../home/rider.nix
  ];

  # Configure home manager
  home.username = "armorynode";
  home.homeDirectory = "/home/armorynode";
  home.stateVersion = "23.11";

  # Packages
  home.packages = (with pkgs; [
    # Customization
    conflux-icon-theme

    # Development
    blackbox-terminal
    ungoogled-chromium
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
    flatpak-xdg-utils

    # Work
    slack
    zoom-us
    teams-for-linux

    # Productivity
    protonmail-desktop
    obsidian

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
