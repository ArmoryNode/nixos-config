{ inputs, config, pkgs, lib, ... }: let
  conflux-icon-theme = pkgs.callPackage ../../modules/custom/themes/conflux-icon-theme.nix {
    src = inputs.conflux-icon-theme;
  };
in
{
  # Configure home manager
  home.username = "armorynode";
  home.homeDirectory = "/home/armorynode";
  home.stateVersion = "23.11";

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
    ../../home/elm.nix
    ../../home/webdev.nix
    ../../home/rider.nix
    ../../home/zenbrowser.nix
    ../../home/blackbox-terminal.nix
  ];

  # Packages
  home.packages = (with pkgs; [
    # Customization
    conflux-icon-theme

    # Development
    ungoogled-chromium
    git
    git-credential-manager

    # Utilities
    geekbench

    # Work
    slack

    # Gaming
    wine
    winetricks
    protontricks

    # Productivity
    protonmail-desktop
    obsidian
  ]);

  # Configure dotfiles
  home.file = {};

  # Configure session variables
  home.sessionVariables = {};

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
