{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  # Configure home manager
  home.username = "armorynode";
  home.homeDirectory = "/home/armorynode";
  home.stateVersion = "23.11";

  # Flatpaks
  services.flatpak.enable = true;
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

  # Packages
  nixpkgs.config.allowUnfree = true;
  home.packages = (with pkgs; [
    # Flatpak
    flatpak

    # Customization
    papirus-icon-theme
    gnome-tweaks

    # Development
    jetbrains.rider
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
  ]) ++ (with pkgs.gnomeExtensions; [
    blur-my-shell
    just-perfection
    reboottouefi
    dash-to-dock
    appindicator
  ]);

  # Additional GNOME configuration
  dconf = {
    enable = true;
    settings."org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [ 
        blur-my-shell.extensionUuid
        dash-to-dock.extensionUuid
        appindicator.extensionUuid
        reboottouefi.extensionUuid
        just-perfection.extensionUuid
      ];
    };
  };

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
