{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Node.js
    nodejs_26

    # Deno
    deno

    # SASS
    dart-sass
  ];
}