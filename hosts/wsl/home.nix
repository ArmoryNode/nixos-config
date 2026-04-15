{ ... }: {
  home.username = "wsl";
  home.homeDirectory = "/home/wsl";
  home.stateVersion = "23.11";

  imports = [
    ../../home/common.nix
    ../../home/nushell.nix
    ../../home/fastfetch.nix
    ../../home/dotnet.nix
    ../../home/git.nix
    ../../home/btop.nix
    ../../home/bat.nix
  ];
}
