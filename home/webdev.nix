{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Node.js
    nodejs_24

    # Deno
    deno

    # SASS
    dart-sass
  ];
}