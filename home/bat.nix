{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "OneHalfDark";
      style = "full";
    };
  };
}
