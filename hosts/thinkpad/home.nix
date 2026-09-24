{ inputs, config, pkgs, lib, ... }: let
  colloid-gtk-custom = pkgs.colloid-gtk-theme.overrideAttrs {
    themeVariants = [ "grey" ];
    colorVariants = [ "dark" ];
    tweaks = [ "rimless" ];
  };
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
  ];

  # Packages
  home.packages = (with pkgs; [
    # Customization
    conflux-icon-theme

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
