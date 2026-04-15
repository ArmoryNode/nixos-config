{ pkgs, ... }: {
  home.packages = with pkgs.nerd-fonts; [
    fira-code
    caskaydia-cove
    caskaydia-mono
    jetbrains-mono
    inconsolata
  ];
}