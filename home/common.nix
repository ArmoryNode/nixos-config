{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    btop
    fastfetch
    zoxide
    fzf
  ];

  # Configure dotfiles
  home.file = {};

  # Configure session variables
  home.sessionVariables = {};

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}