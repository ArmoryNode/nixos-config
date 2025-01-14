{ pkgs, ... }:
{
  home.packages = with pkgs.elmPackages; [
    elm
    elm-live
    elm-test
    elm-format
    elm-review
  ];
}