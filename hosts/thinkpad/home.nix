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
  nixpkgs.config.allowUnfree = true;
  home.packages = (with pkgs; [
    # Flatpak
    flatpak

    # Customization
    papirus-icon-theme

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

  # Configure nushell
  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config = {
        show_banner: false
        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "Fuzzy"
          external: {
            enable: true
            max_results: 100
            completer: null
          }
        }
      }
      $env.PATH = (
        $env.PATH | 
        split row (char esep) |
        prepend /home/armorynode/.apps |
        append /usr/bin/env
      )
    '';
  };
  
  # Configure VSCode
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ionide.ionide-fsharp
      visualstudioexptteam.vscodeintellicode
      ms-dotnettools.csharp
      ms-dotnettools.csdevkit
      github.copilot
    ];
  };

  # Configure dotfiles
  home.file = {};

  # Configure session variables
  home.sessionVariables = {};

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
