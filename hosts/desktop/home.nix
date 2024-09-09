{ config, pkgs, lib, inputs, ... }:
{
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
    ../../home.dotnet.nix
  ];

  # Configure home manager
  home.username = "armorynode";
  home.homeDirectory = "/home/armorynode";
  home.stateVersion = "23.11";

  # Flatpaks
  services.flatpak.enable = true;
  services.flatpak.uninstallUnmanaged = true;
  services.flatpak.packages = [
    "com.spotify.Client"
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
  nixpkgs.config.allowUnfree = true;
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

    # Work
    slack

    # Gaming
    bottles
    wine
    winetricks
    protontricks

    # Nerdfonts
    (pkgs.nerdfonts.override {
      fonts = [
        "FiraCode"
        "CascadiaCode"
        "JetBrainsMono"
        "Inconsolata"
      ];
    })
  ]);

  # Configure git
  programs.git = {
    enable = true;
    userName = "armorynode";
    userEmail = "22787155+ArmoryNode@users.noreply.github.com";
    extraConfig = {
      user.name = "armorynode";
      user.email = "22787155+ArmoryNode@users.noreply.github.com";

      credential.helper = "${
        pkgs.git.override { withLibsecret = true; }
      }/bin/git-credential-libsecret";
    };
  };

  # Configure zshell
  programs.zsh = {
    enable = true;
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
  
  # Configure VSCode
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ionide.ionide-fsharp
      visualstudioexptteam.vscodeintellicode
      ms-dotnettools.csharp
      ms-dotnettools.csdevkit
    ];
  };

  # Configure dotfiles
  home.file = {};

  # Configure session variables
  home.sessionVariables = {};

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
