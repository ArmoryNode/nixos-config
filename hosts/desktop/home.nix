{ config, pkgs, lib, inputs, ... }: let
  conflux-icon-theme = pkgs.callPackage ../../modules/custom/themes/conflux-icon-theme.nix {
    src = inputs.conflux-icon-theme;
  };
  negpy = (inputs.negpy.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ 
      inputs.negpy.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.wrapGAppsHook3
    ];
    buildInputs = (old.buildInputs or []) ++ [ 
      inputs.negpy.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.gtk3
    ];
  }));
in {
  imports = [
    ../../home/common.nix
    ../../home/nushell.nix
    ../../home/blackbox-terminal.nix
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
    inputs.adwair.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Development
    ungoogled-chromium
    csharprepl
    fsautocomplete
    git-credential-manager
    claude-code

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
    wine
    winetricks
    protontricks

    # Media
    pocket-casts
    negpy
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

  # Add tailscale systray
  services.tailscale-systray = {
    enable = true;
  };

  # Configure dotfiles
  home.file = {};

  # Configure session variables
  home.sessionVariables = {};

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
