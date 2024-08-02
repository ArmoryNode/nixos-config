{ config, pkgs, lib, inputs, ... }:
{
  home.username = "armorynode";
  home.homeDirectory = "/home/armorynode";
  home.stateVersion = "23.11";

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
    (with dotnetCorePackages; combinePackages [
      sdk_6_0
      sdk_7_0
      sdk_8_0
      sdk_9_0
    ])
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