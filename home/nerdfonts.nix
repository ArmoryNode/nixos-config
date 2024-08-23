{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (pkgs.nerdfonts.override {
      fonts = [
        "FiraCode"
        "CascadiaCode"
        "JetBrainsMono"
        "Inconsolata"
      ];
    })
  ];
}