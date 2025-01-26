{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Node.js
    nodejs_22

    # Deno
    deno

    # SASS
    dart-sass
  ];
}