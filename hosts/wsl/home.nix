{ ... }:
{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "23.11";

  imports = [
    ../../home/common.nix
    ../../home/nushell.nix
    ../../home/git.nix
  ];
}
